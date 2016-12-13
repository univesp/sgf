class FormVagasRemanescentesController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def index
    @univesp_courses = FormVagasRemanescentes.new.get_univesp_courses

    # if no response object was created in the previous form,
    # the user can not have access to this form
    if not session[:current_response_id] 
      redirect_to action: 'socio_economico'
    end
  end

  def login
    respond_to do |format|
      format.json { render json: current_user.inspect.to_json }
    end
  end

  # Socioeconomic survey
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

    redirect_to action: 'index'
  end


  def save_response
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

end
