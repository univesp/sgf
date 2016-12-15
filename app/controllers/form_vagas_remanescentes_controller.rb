class FormVagasRemanescentesController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :check_if_logged_in, except: [:socio_economico, :login]
  before_action :check_if_responded, only: [:pedido]
  before_action :check_if_has_more_attempts, except: [:final]


  # Common
  # ------------------------------------------------------------ #

  def index
    redirect_to action: 'socio_economico'
  end

  def login
    respond_to do |format|
      format.json { render json: current_user.inspect.to_json }
    end
  end


  # Form "Socioeconômico"
  # ------------------------------------------------------------ #

  # open the socioeconomic survey
  def socio_economico

    # if there is a current response, the form has already been completed
    # and the user came back to it
    if session[:current_response_id]
      current_response = FormResponse.find(session[:current_response_id])
      json_response = JSON.parse(current_response.json_response)
      # multiples responses are allowed but only the last is considered
      # to re-fill the form
      @last_response = json_response['surveys'].last
    else
      @last_response = nil
    end
  end

  # send data from socioeconomic survey to server
  def socio_economico_submit

    # responding for the first time
    if not session[:current_response_id]
      current_response = nil
      # preparing the object to store the surveys and requests data
      json_response = { 'surveys' => [], 'requests' => [] }
    else
      current_response = FormResponse.find(session[:current_response_id])
      json_response = JSON.parse current_response.json_response
    end

    # appending the new response to the array of surveys
    surveys_number = json_response['surveys'].size
    json_response['surveys'] = [] if surveys_number == 0
    json_response['surveys'].push(
      params.merge({
        :attempt => (surveys_number + 1),
        :sent_at => Time.zone.now
      })
    )

    if current_response
      current_response.update({
        json_response: json_response.to_json
      })
    else
      # the response must be created only in this form
      # and not in the request form!
      current_response = FormResponse.create({
        form_id: Form.where(reference_model: 'FormVagasRemanescentes').first.id,
        user: current_user.email,
        json_response: json_response.to_json
      })

      # storing the response id in session to access it
      # from the other form, the request form
      session[:current_response_id] = current_response.id
    end

    redirect_to action: 'pedido'
  end


  # Form "Pedido"
  # ------------------------------------------------------------ #

  def classes_and_activities_by_course

    course = VagasRemanescentesCourse.find(params[:course_id])
    form_model = FormVagasRemanescentes.new

    if session[:current_response_id]
      current_response = FormResponse.find(session[:current_response_id])
      json_response = JSON.parse(current_response.json_response)
      # multiples responses are allowed but only the last is considered
      # to re-fill the form
      last_response = json_response['requests'].last
    end

    # classes
    classes = form_model.get_univesp_classes(course.id)
    @classes1 = {
      :options       => classes,
      :last_response => last_response,
      :field         => 'firstLocation'
    }
    @classes2 = {
      :options       => classes,
      :last_response => last_response,
      :field         => 'secondLocation'
    }
    @classes3 = {
      :options       => classes,
      :last_response => last_response,
      :field         => 'thirdLocation'
    }

    # activities
    if course.parent
      @basic_activities = {
        :activities    => form_model.get_univesp_activities(course.parent.id),
        :course_name   => course.parent.name,
        :workload      => 800,
        :type          => 'basicActivities',
        :last_response => last_response
      }
      @professional_activities = {
        :activities    => form_model.get_univesp_activities(course.id),
        :course_name   => course.name,
        :workload      => 400,
        :type          => 'professionalActivities',
        :last_response => last_response
      }
    else
      @basic_activities = {
        :activities    => form_model.get_univesp_activities(course.id),
        :course_name   => course.name,
        :workload      => 400,
        :type          => 'basicActivities',
        :last_response => last_response
      }
    end

    respond_to do |format|
      format.js
    end
  end

  # HTTP GET
  def pedido

    # Loading courses
    @univesp_courses = FormVagasRemanescentes.new.get_univesp_courses

    # Re-filling the form with last response
    if session[:current_response_id] 
      current_response = FormResponse.find(session[:current_response_id])
      json_response = JSON.parse(current_response.json_response)     
      @last_response = json_response['requests'].last
    end
  end

  # HTTP POST
  def pedido_submit_partial

    submit_pedido

    respond_to do |format|
      format.json { render json: { :status => 'ok' } }
    end
  end

  # HTTP POST
  def pedido_submit_final

    validation = validate_pedido params[:formData]
    if validation[:status] == 'ok'
      submit_pedido
      # cleans session
      session[:current_response_id] = nil
    end

    respond_to do |format|
      format.json { render json: validation }
    end
  end

  def submit_pedido

    res = FormResponse.find(session[:current_response_id])
    json_response = JSON.parse res.json_response

    requests_number = json_response['requests'].size
    json_response['requests'] = [] if requests_number == 0
    json_response['requests'].push(
      params[:formData].merge({
        :attempt => (requests_number + 1),
        :sent_at => Time.zone.now
      })
    )
    res.update({
      json_response: json_response.to_json,
      sent_at: Time.zone.now
    })
  end

  # HTTP POST
  def upload
     begin
      client_file_name = params[:filename]
      hash = params[:hash]
      control = params[:control]

      extension = File.extname client_file_name
      server_file_name = "#{hash}#{extension}"
      server_file_path = "/mnt/nas/sgf/attachs/#{server_file_name}"

      File.open(server_file_path, 'w') do |f|
        f.binmode
        while buffer = request.body.read(51200) # read in 50KB chunks
          f << buffer
        end
      end
      res = { :status => 'OK',  :file => server_file_name }
     rescue StandardError => e
      msg = 'Ocorreu um erro durante o envio do anexo. Por favor, tente novamente dentro de alguns instantes'
      res = { :status => 'EXCEPTION', :message => msg }
     end

    respond_to do |format|
      format.json { render json: res }
    end
  end

  def validate_pedido form_data

    errors = []
    errors << 'Você deve estar de acordo com as condições da Portaria' if form_data[:according] != 'true'
    errors << 'O Nome completo deve ser preenchido' if form_data[:name].blank?
    errors << 'O E-mail deve ser preenchido' if form_data[:email].blank?
    errors << 'O Telefone deve ser preenchido' if form_data[:phone].blank?
    errors << 'O Celular deve ser preenchido' if form_data[:mobile].blank?
    errors << 'O CPF deve ser preenchido' if form_data[:cpf].blank?
    errors << 'A Data de nascimento deve ser preenchida' if form_data[:birthDay] == 'Dia' or form_data[:birthMonth] == 'Mês' or form_data[:birthYear] == 'Ano'
    errors << 'O Curso desejado deve ser preenchido' if form_data[:course].blank?
    errors << 'O anexo de Comprovante de pagamento deve ser carregado' if form_data[:payment].blank?
    errors << 'A INSTITUIÇÃO de origem deve ser preenchida' if form_data[:externalInstitution].blank?
    errors << 'O CURSO deve ser preenchido' if form_data[:externalCourse].blank?
    errors << 'A situação atual deve ser preenchida' if form_data[:courseStatus].blank?
    errors << 'O anexo de Diploma deve ser carregado' if form_data[:diploma].blank? and form_data[:courseStatus] == 'concluded'
    errors << 'O anexo de Atestado de Matrícula deve ser enviado' if form_data[:enrollment].blank? and form_data[:courseStatus] == 'ongoing'
    errors << 'O anexo de Histórico Escolar deve ser enviado' if form_data[:academicRecord].blank?
    errors << 'Você deve escolher a primeira opção de POLO Univesp' if form_data[:firstLocation].blank?
    errors << 'Você deve assinalar a confirmação dos polos' if form_data[:locationConfirm] != 'true'

    # basic activities
    if ['2','3'].include?(form_data[:course].to_s) # Engenharia da Computação ou de Produção
      basic_course = "CICLO BÁSICO DE ENGENHARIA"
      basic_min_workload = 800
    else
      basic_course = VagasRemanescentesCourse.find(form_data[:course].to_i).name
      basic_min_workload = 400
    end
    if form_data[:basicActivities]
      external_workloads = 0
      form_data[:basicActivities].flat_map {|i| i[1] }.each do |activity|
        external_workloads += activity[:externalWorkload].to_i
      end
      errors << "Você deve comprovar a carga horária mínima do curso de #{basic_course}" if external_workloads < basic_min_workload
    else
      errors << "Você deve comprovar a carga horária mínima do curso de #{basic_course}"
    end

    # professional activities
    professional_course = VagasRemanescentesCourse.find(form_data[:course].to_i).name
    professional_min_workload = 400
    if form_data[:professionalActivities]
      external_workloads = 0
      form_data[:professionalActivities].flat_map {|i| i[1] }.each do |activity|
        external_workloads += activity[:externalWorkload].to_i
      end
      errors << "Você deve comprovar a carga horária mínima do curso de #{professional_course}" if external_workloads < professional_min_workload
    elsif ['2','3'].include?(form_data[:course].to_s) # Engenharia da Computação ou de Produção
      errors << "Você deve comprovar a carga horária mínima do curso de #{professional_course}"
    end

    return { :status => 'error', :errors => errors } if errors.size >= 1
    return { :status => 'ok' }
  end
  

  # Form "Final"
  # ------------------------------------------------------------ #

  def final
  end


  # Checks
  # ------------------------------------------------------------ #
  private

  def check_if_logged_in
    redirect_to action: 'socio_economico' if not current_user
  end

  def check_if_responded
    if current_user
      form = Form.where(reference_model: 'FormVagasRemanescentes').first
      number_responses = FormResponse.where(form_id: form.id, user: current_user.email).size
      # if no response object was created in the previous form,
      # the user can not have access to this form 
      redirect_to action: 'socio_economico' unless number_responses >= 1
    end
  end

  def check_if_has_more_attempts
    if current_user
      form = Form.where(reference_model: 'FormVagasRemanescentes').first
      number_responses = FormResponse.where(form_id: form.id, user: current_user.email).size
      redirect_to action: 'final' if number_responses == form.max_attemps
    end
  end

end
