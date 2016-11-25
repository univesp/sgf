class FormVagasRemanescentes

	def get_univesp_disciplinas
		disciplinas = []

		disciplinas << { :value => 1, :text => 'Bancos de Dados' }
		disciplinas << { :value => 2, :text => 'Circuitos Elétricos' }

		disciplinas
	end

	def get_univesp_cursos
		cursos = []

		cursos << {:text => ''}
		cursos << {:value => 3, :text => 'CICLO BÁSICO DE ENGENHARIA'}
		cursos << {:value => 4, :text => 'ENGENHARIA DE COMPUTAÇÃO'}
		cursos << {:value => 5, :text => 'ENGENHARIA DE PRODUÇÃO'}
		cursos << {:value => 6, :text => 'LICENCIATURA EM BIOLOGIA'}
		cursos << {:value => 7, :text => 'LICENCIATURA EM FÍSICA'}
		cursos << {:value => 8, :text => 'LICENCIATURA EM MATEMÁTICA'}
		cursos << {:value => 9, :text => 'LICENCIATURA EM QUÍMICA'}

		cursos
	end

	def get_univesp_polos1
		polos1 = []

		polos1 << {:text => ''}
		polos1 << {:value => 10, :text => 'ENGENHARIA-ARARAS-2N - Segunda-feira - NOITE'}
		polos1 << {:value => 11, :text => 'ENGENHARIA-ARARAS-5N - Quinta-feira - NOITE'}
		polos1 << {:value => 12, :text => 'ENGENHARIA-ARARAS-3T - Quinta-feira - NOITE'}
		polos1 << {:value => 13, :text => 'ENGENHARIA-BARRETOS-SM - Sábado - MANHÃ'}
		polos1 << {:value => 14, :text => 'ENGENHARIA-DIADEMA-ST - Sábado - TARDE'}

		polos1
	end

	def get_univesp_polos2
		polos2 = []

		polos2 << {:text => ''}
		polos2 << {:value => 15, :text => 'ENGENHARIA-ARARAS-2N - Segunda-feira - NOITE'}
		polos2 << {:value => 16, :text => 'ENGENHARIA-ARARAS-5N - Quinta-feira - NOITE'}
		polos2 << {:value => 17, :text => 'ENGENHARIA-BARRETOS-4N - Quarta-feira - NOITE'}
		polos2 << {:value => 18, :text => 'ENGENHARIA-BARRETOS-SM - Sábado - MANHÃ'}
		polos2 << {:value => 19, :text => 'ENGENHARIA-DIADEMA-ST - Sábado - TARDE'}

		polos2
	end

	def get_univesp_polos3
		polos3 = []

		polos3 << {:text => ''}
		polos3 << {:value => 20, :text => 'ENGENHARIA-ARARAS-2N - Segunda-feira - NOITE'}
		polos3 << {:value => 20, :text => 'ENGENHARIA-ARARAS-5N - Quinta-feira - NOITE'}
		polos3 << {:value => 20, :text => 'ENGENHARIA-BARRETOS-4N - Quarta-feira - NOITE'}
		polos3 << {:value => 20, :text => 'ENGENHARIA-BARRETOS-SM - Sábado - MANHÃ'}
		polos3 << {:value => 20, :text => 'ENGENHARIA-DIADEMA-ST - Sábado - TARDE'}

		polos3
	end
end