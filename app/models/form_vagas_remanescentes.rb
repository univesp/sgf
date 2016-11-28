class FormVagasRemanescentes

	def get_univesp_courses
		courses = []

		courses << {:text => ''}
		courses << {:value => 3, :text => 'CICLO BÁSICO DE ENGENHARIA'}
		courses << {:value => 4, :text => 'ENGENHARIA DE COMPUTAÇÃO'}
		courses << {:value => 5, :text => 'ENGENHARIA DE PRODUÇÃO'}
		courses << {:value => 6, :text => 'LICENCIATURA EM BIOLOGIA'}
		courses << {:value => 7, :text => 'LICENCIATURA EM FÍSICA'}
		courses << {:value => 8, :text => 'LICENCIATURA EM MATEMÁTICA'}
		courses << {:value => 9, :text => 'LICENCIATURA EM QUÍMICA'}

		courses
	end

	def get_univesp_poles1
		poles1 = []

		poles1 << {:text => ''}
		poles1 << {:value => 10, :text => 'ENGENHARIA-ARARAS-2N - Segunda-feira - NOITE'}
		poles1 << {:value => 11, :text => 'ENGENHARIA-ARARAS-5N - Quinta-feira - NOITE'}
		poles1 << {:value => 12, :text => 'ENGENHARIA-ARARAS-3T - Quinta-feira - NOITE'}
		poles1 << {:value => 13, :text => 'ENGENHARIA-BARRETOS-SM - Sábado - MANHÃ'}
		poles1 << {:value => 14, :text => 'ENGENHARIA-DIADEMA-ST - Sábado - TARDE'}

		poles1
	end

	def get_univesp_poles2
		poles2 = []

		poles2 << {:text => ''}
		poles2 << {:value => 15, :text => 'ENGENHARIA-ARARAS-2N - Segunda-feira - NOITE'}
		poles2 << {:value => 16, :text => 'ENGENHARIA-ARARAS-5N - Quinta-feira - NOITE'}
		poles2 << {:value => 17, :text => 'ENGENHARIA-BARRETOS-4N - Quarta-feira - NOITE'}
		poles2 << {:value => 18, :text => 'ENGENHARIA-BARRETOS-SM - Sábado - MANHÃ'}
		poles2 << {:value => 19, :text => 'ENGENHARIA-DIADEMA-ST - Sábado - TARDE'}

		poles2
	end

	def get_univesp_poles3
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