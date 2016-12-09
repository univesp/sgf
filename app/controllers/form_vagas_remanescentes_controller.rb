class FormVagasRemanescentesController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def index
    @univesp_courses = FormVagasRemanescentes.new().get_univesp_courses
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

end
