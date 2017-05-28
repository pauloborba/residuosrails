Given(/^o sistema possui o departamento de "([^"]*)"cadastrado$/) do |dep_name|
	Department.create(name: dep_name)
	teste = Department.find_by_name(dep_name)
	assert true
end

Given(/^o sistema possui o laboratorio de "([^"]*)" cadastrado no departamento de "([^"]*)"$/) do |lab_name, dep_name|
     dep = Department.find_by_name(dep_name)
	 Laboratory.create(name: lab_name, dep_name: dep_name)
end
=begin
Given(/^o sistema possui "([^"]*)" de residuos cadastrados no laboratorio de "([^"]*)"$/) do |res_weight, lab_name|
	lab = Laboratory.where(name: lab_name)[0] != nil
	assert lab != nil
	param_res1 = {residue: {name: "Acido", laboratory: lab_name, weigth: res_weight}}
	post '/residues', param_res1
	assert Department.total_residues() == res_weight
end

when(/^eu tento produzir o relatório do total de residuos cadastrados entre as datas "([^"]*)" e "([^"]*)" para o "([^"]*)"$/) do |data_begin, data_final, dep_name|
	assert Departament.where(name: dep_name)[0] != nil
	residues_total = Department.where(created_at:[data_inicio.to_date..data_fim.to_date])
	
	post generate_report 
end

Then(/^o valor retornado pelo sistema será  de "([^"]*)"$/) do |res_wight|
	assert Department.total_residues() == res_weight
end

=begin
*************************************************************************************************************************************************************************************
	
Given(/^o sistema possui "([^"]*)" de residuos cadastrados entre as datas "([^"]*)" e "([^"]*)" no laboratorio de "([^"]*)"$/ do |res_weight, data_begin, data_final, lab_name|
	assert Laboratoy.where(name: lab_name)[0] != nil
	param_res1 = {residue: {name: "Acido", laboratory: lab_name, weigth: res_weight}}
	post '/residues', param_res1
	assert Residue.where(param_res1) != nil
	res = Residue.where(created_at:[data_inicio.to_date..data_fim.to_date])
	assert total_weight(res) = res_weight
	
end
=end
 