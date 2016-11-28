class FormVagasRemanescentesController < ApplicationController
	def index
		@univesp_courses = FormVagasRemanescentes.new().get_univesp_courses
		@univesp_poles1 = FormVagasRemanescentes.new().get_univesp_poles1
		@univesp_poles2 = FormVagasRemanescentes.new().get_univesp_poles2
		@univesp_poles3 = FormVagasRemanescentes.new().get_univesp_poles3
	end
end
