Feature: Geração de Relatórios
    	As a usuário Administrador
	    I want to gerar relatórios
    	So that é possível fazer análise dos dados de modo mais simples
    	
    	
Scenario: Produzir um relatório do total de resíduo(s), por Laboratório / Departamento / Resíduos entre datas específicas
Given  o sistema possui o "Departamento de Engenharia Química"cadastrado
And o o sistema possui o laboratório de  "Processos Químicos" está cadastrado no departamento de "Engenharia Química"
And o sistema possui "500" kg de resíduos cadastrados no laboratório de "Processos Químicos"
When eu tento produzir o relatório total de resíduos cadastrados entre as datas "21/02/2017" e "24/03/2017" para o "Departamento de Engenharia Química"
Then o valor retornado pelo sistema será "500" kg.
    	

Scenario: Produzir um relatório mensal para um Departamento / Laboratório / Resíduos  específico. 
Given o sistema possui o "Departamento de Engenharia Química" cadastrado.
And o sistema possui "300" kg de resíduos cadastrados entre entre as datas "21/02/2017" e "21/03/2017" para o "Departamento de Engenharia Química" 
And o sistema possui "700" kg de resíduos cadastrados entre entre as datas "22/03/2017" e "23/03/2017" para o "Departamento de Engenharia Química"
When eu tento produzir o relatório total de resíduos cadastrados entre as datas  "21/02/2017" e "21/03/2017" para o "Departamento de Engenharia Química"
Then o valor retornado pelo sistema será de "300 kg"

Scenario: Produzir relatório de resíduos por laboratório entre datas específicas. 
Given que eu estou na página "Geração de Relatórios"
And a opção de gerar por "laboratório" está selecionada
And eu vejo uma lista de "laboratórios" disponíveis no sistema.
And  eu seleciono o "Laboratório de Processos Químicos"
And no campo  "Data" eu vejo "21/02/2017" para início  e "24/03/2017" para final.
When eu peço para "Gerar Relatório"
And eu vou para a página de resumo de sistema
Then eu devo visualizar a quantidade de resíduos produzidos, associado ao "Laboratório de Processos Químicos" entre as datas  "21/02/2017" e  "24/03/2017"

Scenario: Produzir relatório mensal do total de resíduo(s) para um departamento específico.
Given  que eu estou na página "Geração de Relatórios"
And  opção de gerar por "Departamento" está selecionada
And eu vejo uma lista de "Departamento" disponíveis no sistema.
And  eu seleciono o "Departamento de Engenharia Química"
And no campo  "Data" eu vejo "21/02/2017" para início  e "21/03/2017" para final.
When eu peço para gerar "Gerar Relatório"
And vou para a página de resumo de sistema
Then eu devo visualizar a quantidade de resíduos produzidos associado ao "Departamento de Engenharia Química" entre as datas  "21/02/2017" e  "21/03/2017"




        
        

