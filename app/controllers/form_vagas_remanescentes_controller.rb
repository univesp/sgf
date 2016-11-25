class FormVagasRemanescentesController < ApplicationController
	def index
		@univesp_disciplinas = FormVagasRemanescentes.new().get_univesp_disciplinas
		@univesp_cursos = FormVagasRemanescentes.new().get_univesp_cursos
		@univesp_polos1 = FormVagasRemanescentes.new().get_univesp_polos1
		@univesp_polos2 = FormVagasRemanescentes.new().get_univesp_polos2
		@univesp_polos3 = FormVagasRemanescentes.new().get_univesp_polos3
	end
end
