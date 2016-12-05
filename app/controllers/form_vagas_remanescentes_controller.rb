class FormVagasRemanescentesController < ApplicationController
	def index
 		@univesp_courses = FormVagasRemanescentes.new().get_univesp_courses                
		@univesp_poles1 = FormVagasRemanescentes.new().get_univesp_poles1
		@univesp_poles2 = FormVagasRemanescentes.new().get_univesp_poles2
		@univesp_poles3 = FormVagasRemanescentes.new().get_univesp_poles3
                @univesp_activities = FormVagasRemanescentes.new.get_univesp_activities 1
	end

  def univesp_activities_by_course
    @univesp_activities = FormVagasRemanescentes.new.get_univesp_activities params[:course_id]
    puts "univesp_activities_by_course @univesp_activities: #{@univesp_activities.inspect}"
    respond_to do |format|
      format.js
    end
  end

end
