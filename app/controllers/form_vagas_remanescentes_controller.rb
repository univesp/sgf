class FormVagasRemanescentesController < ApplicationController
	def index
		@univesp_courses = FormVagasRemanescentes.new().get_univesp_courses
		@univesp_classes = FormVagasRemanescentes.new().get_univesp_classes 1
		@univesp_activities = FormVagasRemanescentes.new().get_univesp_activities 1
		@univesp_poles3 = FormVagasRemanescentes.new().get_univesp_poles3
	end

	def univesp_activities		
		course_id = params[:courseId]
		options = FormVagasRemanescentes.new.get_univesp_activities course_id
		render json: options.to_json
	end

	def univesp_classes
		course_id = params[:courseId]
		options = FormVagasRemanescentes.new.get_univesp_classes course_id
		render json: options.to_json
	end
end
