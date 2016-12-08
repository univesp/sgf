class FormVagasRemanescentesController < ApplicationController

  def index
    @univesp_courses = FormVagasRemanescentes.new().get_univesp_courses
    @univesp_classes = FormVagasRemanescentes.new.get_univesp_classes 1
    @univesp_poles1 = FormVagasRemanescentes.new().get_univesp_poles
    @univesp_poles2 = FormVagasRemanescentes.new().get_univesp_poles # TODO: implement get_univesp_poles2
    @univesp_poles3 = FormVagasRemanescentes.new().get_univesp_poles # TODO: implement get_univesp_poles2
    @univesp_activities = FormVagasRemanescentes.new.get_univesp_activities 1
  end

  def univesp_activities_by_course
    course = VagasRemanescentesCourse.find(params[:course_id])
    if course.parent
      @basic_activities = {
        :activities => FormVagasRemanescentes.new.get_univesp_activities(course.parent.id),
        :workload   => 800,
        :type       => 'basic'
      }
      @professional_activities = {
        :activities => FormVagasRemanescentes.new.get_univesp_activities(course.id),
        :workload   => 400,
        :type       => 'professional'
      }
    else
      @basic_activities = {
        :activities => FormVagasRemanescentes.new.get_univesp_activities(course.id),
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
