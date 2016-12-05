class FormVagasRemanescentes

	def get_univesp_courses
		courses = []

		courses << {:text => 'Selecione o Curso'}
		VagasRemanescentesCourse.all.each do |course|
			courses << {:value => course.id, :text => course.name}
		end

		courses
	end

	def get_univesp_classes course_id
		classes = []

		classes << {:text => 'Selecione o Polo'}
		VagasRemanescentesClass.where(vagas_remanescentes_course_id: course_id).each do |classe|
			classes << {:value => classe.id, :text => classe.name}
		end

		classes
	end

	def get_univesp_activities course_id
		activities = []

		VagasRemanescentesActivity.where(vagas_remanescentes_course_id: course_id).each do |activity|
			activities << {:value => activity.id, :text => activity.name}
		end

		activities
	end

	def get_univesp_poles
		poles3 = []

		poles3 << {:text => ''}
		poles3 << {:value => 20, :text => 'ENGENHARIA-ARARAS-2N - Segunda-feira - NOITE'}
		poles3 << {:value => 20, :text => 'ENGENHARIA-ARARAS-5N - Quinta-feira - NOITE'}
		poles3 << {:value => 20, :text => 'ENGENHARIA-BARRETOS-4N - Quarta-feira - NOITE'}
		poles3 << {:value => 20, :text => 'ENGENHARIA-BARRETOS-SM - Sábado - MANHÃ'}
		poles3 << {:value => 20, :text => 'ENGENHARIA-DIADEMA-ST - Sábado - TARDE'}

		poles3
	end

end
