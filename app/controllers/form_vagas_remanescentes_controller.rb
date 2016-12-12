class FormVagasRemanescentesController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  #before_action :check_login, except: [:login]

  def index
    @univesp_courses = FormVagasRemanescentes.new().get_univesp_courses
  end

  def login
    respond_to do |format|
      format.json { render json: current_user.inspect.to_json }
    end
  end

  def socio_economico

  end

  def socio_economico_submit
    redirect_to action: 'index'
  end


  def save_response
    json_response = params[:formData].to_json

    reference_form = Form.where(reference_model: 'FormVagasRemanescentes').first
    user = ''
    user = current_user.email if current_user

    res = FormResponse.create({
      form_id: reference_form.id,
      user: user,
      status: 'sent',
      json_response: json_response,
      json_updated_at: Time.zone.now,
      sent_at: Time.zone.now
    })

    respond_to do |format|
      format.js {}
      format.json {
        render json: { :res => res.inspect }
      }
    end
  end

  def classes_and_activities_by_course
    course = VagasRemanescentesCourse.find(params[:course_id])
    form_model = FormVagasRemanescentes.new

    # classes
    classes = form_model.get_univesp_classes(course.id)
    @classes = {
      :options => classes
    }

    # activities
    if course.parent
      @basic_activities = {
        :activities => form_model.get_univesp_activities(course.parent.id),
        :workload   => 800,
        :type       => 'basic'
      }
      @professional_activities = {
        :activities => form_model.get_univesp_activities(course.id),
        :workload   => 400,
        :type       => 'professional'
      }
    else
      @basic_activities = {
        :activities => form_model.get_univesp_activities(course.id),
        :workload   => 400,
        :type       => 'basic'
      }
    end

    respond_to do |format|
      format.js
    end
  end

  def univesp_classes
    course_id = params[:courseId]
    options = FormVagasRemanescentes.new.get_univesp_classes course_id
    render json: options.to_json
  end

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

  #private

  #def check_login
  #  if not current_user
  #    #redirect_to action: 'login'
  #    respond_to do |format|
  #      format.html
  #      format.js
  #    end
  #  end
  #end

end
