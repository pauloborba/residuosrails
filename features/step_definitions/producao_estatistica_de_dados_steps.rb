@collection = []
Given(/^existe "([^"]*)" kg de residuos cadastrados no sistema$/) do |res_weight|
 dep_name = "Departamento de Genetica"
 lab_name = "Laboratorio de Genetica Aplicada"
 res_name = "Etanol"
 res_type = "Líquido Inflamável"
 col = cad_col(0)
 expect(col).to_not be nil
 dep = cad_dep(dep_name)
 expect(dep).to_not be nil
 lab = cad_lab(lab_name, dep.id)
 expect(lab).to_not be nil
 res = cad_res(res_name,lab.id,res_type)
 expect(res).to_not be nil
 reg = cad_reg(res_weight.to_f(),res.id)
 expect(reg).to_not be nil
end
 
Given(/^a ultima coleta foi feita a "([^"]*)" dias$/) do |last_collection|
 @collection = Collection.last
 @collection.created_at= (@collection.created_at.to_date - 10)
 @collection.save
end
 
Given(/^o limite de peso de residuos é "([^"]*)" kg$/) do |limit_weight|
 @collection = Collection.last
 @collection.max_value=limit_weight
 @collection.save
end

When(/^eu tento gerar a "([^"]*)"$/) do |action|
 if action == "Previsão de Notificação de Coleta"
  @collection = Collection.last
  @collection.generate_prediction
 end
end
 
Then(/^o sistema calcula a média de "([^"]*)" kg\/dia$/) do |mean|
 expect(@collection.mean).to eq(mean.to_f())
end
 
Then(/^o sistema calcula que faltam "([^"]*)" kg para atingir o limite$/) do |miss_weight|
  expect(miss_weight.to_f()).to eq(@collection.miss_weight)
end
 
Then(/^o sistema calcula que faltam "([^"]*)" dias para fazer a licitação$/) do |miss_days|
 expect(miss_days.to_i()).to eq(@collection.miss_days)
end

def cad_col(max_value)
 col = {collection: {max_value: max_value}}
 post '/collections', col
 return Collection.find_by(max_value: max_value)
end
 
def cad_dep(dep_name)
 dep = {department: {name: dep_name}}
 post '/departments', dep
 return Department.find_by(name: dep_name)
end
 
def cad_lab(lab_name, dep_id)
 lab = {laboratory: {name: lab_name, department_id: dep_id}}
 post '/laboratories', lab
 return Laboratory.find_by(name: lab_name)
end
 
def cad_res(res_name, lab_id,res_type)
 res = {residue: {name: res_name, kind: res_type, laboratory_id: lab_id}}
 post '/residues', res
 return Residue.find_by(name: res_name)
end

def cad_reg(weight, res_id)
 reg = {register: {weight: weight.to_f(), residue_id: res_id}}
 post '/registers', reg
 return Register.find_by(residue_id: res_id)
end

Given(/^existe "([^"]*)" kg de "([^"]*)" de tipo "([^"]*)" cadastrado no sistema$/) do |res_weight, res_name, res_type|
 dep_name = "Departamento de Genetica"
 lab_name = "Laboratorio de Genetica Aplicada"
 limit_weight = 7500
 if Collection.all.empty?
  col = cad_col(limit_weight) 
  expect(col).to_not be nil
 end
 if Department.all.empty? 
  dep = cad_dep(dep_name)
  expect(dep).to_not be nil
 end
 if Laboratory.all.empty?
  lab = cad_lab(lab_name, dep.id)
  expect(lab).to_not be nil
 end
 lab = Laboratory.find_by(name: lab_name)
 res = cad_res(res_name,lab.id,res_type)
 expect(res).to_not be nil
 reg = cad_reg(res_weight.to_f(),res.id)
 expect(reg).to_not be nil
end
 
When(/^eu tento gerar o "([^"]*)"$/) do |action|
 if action == "Total de Resíduos Acumulados por Tipo"
  @collection = Collection.last
  @collection.type_residue
 elsif action == "Total de Resíduos Acumulados por Tipo em Porcentagem"
  @collection = Collection.last
  @collection.type_residue_percent
 elsif action == "Resíduo Mais Frequentemente Cadastrado por Laboratorio"
  @collection = Collection.last
  @collection.residue_often_registered
 elsif action == "Total de Resíduos Acumulados por Departamento"
  @collection = Collection.last
  @collection.dep_residue
 end
end

Then(/^o sistema calcula o  "([^"]*)" com "([^"]*)" kg de substâncias de tipo "([^"]*)" e "([^"]*)" kg de substâncias de tipo "([^"]*)"$/) do |action,res_weight1,res_type1,res_weight2,res_type2|
 if action == "Total de Resíduos Acumulados por Tipo"
  validate(res_type1, res_weight1)
  validate(res_type2, res_weight2)
 end
end

def validate(res_type, res_weight)
 case res_type
 when "Sólido Orgânico"
  expect(@collection.solido_organico).to eq(res_weight.to_f())
 when "Sólido Inorgânico"
  expect(@collection.solido_inorganico).to eq(res_weight.to_f())
 when "Líquido Orgânico"
  expect(@collection.liquido_organico).to eq(res_weight.to_f())
 when "Líquido Inorgânico"
  expect(@collection.liquido_inorganico).to eq(res_weight.to_f())
 when "Líquido Inflamável"
  expect(@collection.liquido_inflamavel).to eq(res_weight.to_f())
 when "Outros"
  expect(@collection.outros).to eq(res_weight.to_f())
 end
end

Given(/^eu estou na página de estatistica$/) do
  visit 'statistic'
end

Given(/^eu vejo a lista de "([^"]*)" vazia$/) do |list|
  element = find("th", text: list)
  expect(element).to_not be nil
  expect(find("table").find("tbody").find("tr").has_no_css?("td")).to be true
 end

 When(/^eu seleciono a opção "([^"]*)"$/) do |action|
  click_on(action)
 end

 Then(/^eu vejo uma mensagem informando que não há resíduos cadastrados$/) do
  element = page.find("textarea")
  expect(element.value).to eq("Não existe resíduos cadastrados")
  #page.save_screenshot()
 end
 
 Given(/^eu vejo a lista de "([^"]*)"$/) do |list|
  element = find("th", text: list)
  expect(element).to_not be nil
 end
 
 Given(/^eu vejo "([^"]*)" kg de "([^"]*)" de tipo "([^"]*)"$/) do |res_weight, res_name, res_type|
  dep_name = "Departamento de Filosofia"
  lab_name = "Laboratorio de Logica"
  limit_weight = 7500
  visit 'collections'
  if find("table").find("tbody").has_no_css?("tr")
   cad_col_gui(limit_weight)
  end
  visit 'departments'
  if find("table").find("tbody").has_no_css?("tr")
   cad_dep_gui(dep_name)
  end
  visit 'laboratories'
  if find("table").find("tbody").has_no_css?("tr")
   cad_lab_gui(lab_name,dep_name)
  end
  cad_res_gui(res_name,lab_name,res_type)
  cad_reg_gui(res_weight,res_name)
  visit 'statistic'
  expect(page).to have_content res_name+" "+res_type+" "+res_weight
end

Then(/^eu vejo uma lista com o "([^"]*)" com  "([^"]*)" kg de substâncias de tipo "([^"]*)" e "([^"]*)" kg de substâncias de tipo "([^"]*)"$/) do |list, res_weight1, res_type1, res_weight2, res_type2|
  element = find("th", text: "Total de Resíduos Acumulados por Tipo")
  expect(element.text).to eq(list)
  expect(page).to have_content res_type1+" "+res_weight1
  expect(page).to have_content res_type2+" "+res_weight2
end
 
 def cad_col_gui(max_value) 
  visit '/collections/new'
  fill_in('collection_max_value', :with => max_value)
  click_button 'Create Collection'
 end
 
 def cad_dep_gui(dep_name)
  visit '/departments/new'
  fill_in('department_name', :with => dep_name)
  click_button 'Create Department'
 end

def cad_lab_gui(lab_name, dep_name)
  visit '/laboratories/new'
  fill_in('laboratory_name', :with => lab_name)
  page.select dep_name, :from => 'laboratory_department_id'
  click_button 'Create Laboratory'
  
end

def cad_res_gui(res_name, lab_name,res_type)
  visit '/residues/new'
  fill_in('residue_name', :with => res_name)
  page.select res_type, :from => 'residue_kind'
  page.select lab_name, :from => 'residue_laboratory_id'
  click_button 'Create Residue'
end

def cad_reg_gui(weight, res_name)
  visit '/registers/new'
  fill_in('register_weight', :with => weight)
  page.select res_name, :from => 'register_residue_id'
  click_button 'Create Register'
end

Then(/^o sistema calcula o  "([^"]*)" com "([^"]*)"% de substâncias de tipo "([^"]*)" e "([^"]*)"% de substâncias de tipo "([^"]*)"$/) do |action, res_percent1, res_type1, res_percent2, res_type2|
 if action == "Total de Resíduos Acumulados por Tipo em Porcentagem"
  validate_percent(res_type1, res_percent1)
  validate_percent(res_type2, res_percent2)
 end
end

def validate_percent(res_type, res_percent)
 case res_type
 when "Sólido Orgânico"
  expect(@collection.solido_organico_percent).to eq(res_percent.to_f())
 when "Sólido Inorgânico"
  expect(@collection.solido_inorganico_percent).to eq(res_percent.to_f())
 when "Líquido Orgânico"
  expect(@collection.liquido_organico_percent).to eq(res_percent.to_f())
 when "Líquido Inorgânico"
  expect(@collection.liquido_inorganico_percent).to eq(res_percent.to_f())
 when "Líquido Inflamável"
  expect(@collection.liquido_inflamavel_percent).to eq(res_percent.to_f())
 when "Outros"
  expect(@collection.outros_percent).to eq(res_percent.to_f())
 end
end

Given(/^existe "([^"]*)" kg de "([^"]*)" no "([^"]*)" com "([^"]*)" registros$/) do |res_weight, res_name, lab_name, reg_number|
 dep_name = "Departamento de Genetica"
 res_type = "Líquido Inflamável"
 limit_weight = 7500
 if Collection.all.empty?
  col = cad_col(limit_weight) 
  expect(col).to_not be nil
 end
 if Department.all.empty? 
  dep = cad_dep(dep_name)
  expect(dep).to_not be nil
 end
 dep = Department.find_by(name: dep_name)
 if Laboratory.find_by(name: lab_name).nil?
  lab = cad_lab(lab_name, dep.id)
  expect(lab).to_not be nil
 end
 lab = Laboratory.find_by(name: lab_name)
 res = cad_res(res_name,lab.id,res_type)
 expect(res).to_not be nil
 reg = cad_reg(res_weight.to_f(),res.id)
 expect(reg).to_not be nil
 num = reg_number.to_i() - 1
 while num > 0
  reg = cad_reg(0,res.id)
  expect(reg).to_not be nil
  num -= 1
 end
end

Then(/^o sistema calcula o "([^"]*)" com "([^"]*)" para o "([^"]*)" e com "([^"]*)" para o "([^"]*)"$/) do |action, res_name1, lab_name1, res_name2, lab_name2|
 if action ==  "Resíduo Mais Frequentemente Cadastrado por Laboratorio"
  expect(@collection.residue_often_registered_list[lab_name1.parameterize.underscore.to_sym]).to eq(res_name1)
  expect(@collection.residue_often_registered_list[lab_name2.parameterize.underscore.to_sym]).to eq(res_name2)
 end
end

Then(/^eu vejo uma lista com o "([^"]*)" com "([^"]*)"% de substâncias de tipo "([^"]*)" e "([^"]*)"% de substâncias de tipo "([^"]*)"$/) do |list, res_percent1, res_type1, res_percent2, res_type2|
 element = find("th", text: "Total de Resíduos Acumulados por Tipo em Porcentagem")
 expect(element.text).to eq(list)
 expect(page).to have_content res_type1+" "+res_percent1+"%"
 expect(page).to have_content res_type2+" "+res_percent2+"%"
end

Given(/^eu vejo "([^"]*)" kg de "([^"]*)" no "([^"]*)" com "([^"]*)" registros$/) do |res_weight, res_name, lab_name, reg_number|
 dep_name = "Departamento de Filosofia"
 res_type = "Líquido Inflamável"
 limit_weight = 7500
  visit 'collections'
  if find("table").find("tbody").has_no_css?("tr")
   cad_col_gui(limit_weight)
  end
  visit 'departments'
  if find("table").find("tbody").has_no_css?("tr")
   cad_dep_gui(dep_name)
  end
  visit 'laboratories'
  if find("table").find("tbody").has_no_css?("tr") or find("table").find("tbody").has_no_css?("td", text: lab_name)
   cad_lab_gui(lab_name,dep_name)
  end
  cad_res_gui(res_name,lab_name,res_type)
  cad_reg_gui(res_weight,res_name)
  num = reg_number.to_i() - 1
  while num > 0
   reg = cad_reg_gui(0,res_name)
   expect(reg).to_not be nil
   num -= 1
  end
  visit 'statistic'
end

Then(/^eu vejo a lista "([^"]*)" com "([^"]*)" para o "([^"]*)" e com "([^"]*)" para o "([^"]*)"$/) do |list, res_name1, lab_name1, res_name2, lab_name2|
 element = find("th", text: "Resíduo Mais Frequentemente Cadastrado por Laboratorio")
 expect(element.text).to eq(list)
 expect(page).to have_content lab_name1+" "+res_name1
 expect(page).to have_content lab_name2+" "+res_name2
end

Given(/^que o "([^"]*)" e o "([^"]*)" estão cadastrados no sistema$/) do |dep_name1, dep_name2|
  param_dep1 = cad_dep(dep_name1)
  expect(param_dep1).to_not be nil
  param_dep2 = cad_dep(dep_name2)
  expect(param_dep2).to_not be nil
end

Given(/^que "([^"]*)" kg de "([^"]*)" estão no "([^"]*)"$/) do |res_weight, res_name, dep_name|
 if Collection.all.empty?
  param_col = cad_col(0)
  expect(param_col).to_not be nil
 end
 param_dep = Department.find_by(name: dep_name)
 expect(param_dep).to_not be nil
 param_lab = cad_lab("Laboratorio de Genetica Aplicada " + dep_name, param_dep.id)
 expect(param_lab).to_not be nil
 name = res_name + " " + param_lab.name
 param_res = cad_res(name, param_lab.id, "Líquido Inflamável")
 expect(param_res).to_not be nil
 param_reg = cad_reg(res_weight.to_f(), param_res.id)
 expect(param_reg).to_not be nil
end

Then(/^o sistema calcula o "([^"]*)" com "([^"]*)" kg para o "([^"]*)" e "([^"]*)" kg para o "([^"]*)"$/) do |action, res_weight1, dep_name1, res_weight2, dep_name2|
  if action == "Total de Resíduos Acumulados por Departamento"
   expect(@collection.dep_residue_weight[dep_name1.parameterize.underscore.to_sym]).to eq(res_weight1.to_f())
   expect(@collection.dep_residue_weight[dep_name2.parameterize.underscore.to_sym]).to eq(res_weight2.to_f())
  end
end

When(/^eu tento calcular a "([^"]*)"$/) do |action|
  if action == "Quantidade Média de Resíduos Cadastrados"
   @collection = Collection.last
   @collection.generate_prediction
  elsif action == "Quantidade Média de Resíduos Cadastrados por Tipo"
   @collection = Collection.last
   @collection.generate_mean_type
  elsif action == "Quantidade Média de Resíduos Cadastrados por Departamento"
   @collection = Collection.last
   @collection.calc_mean_dep
  end
end

Given(/^eu vejo que o total de resíduos armazenados é "([^"]*)" kg$/) do |res_weight|
  cad_col_gui(7500)
  cad_dep_gui("Departamento de Anatomia Humana")
  cad_lab_gui("Laboratorio de Genetica Aplicada", "Departamento de Anatomia Humana")
  cad_res_gui("Cal", "Laboratorio de Genetica Aplicada", "Líquido Inflamável")
  cad_reg_gui(res_weight, "Cal")
  visit 'statistic'
  total = res_weight.to_f()
  str = "Peso Total: " + total.to_s
  p str
  element = find("th", text: str)
  expect(element).to_not be nil
end

Given(/^eu vejo que a última coleta foi feita a "([^"]*)" dias$/) do |last_collection|
  str = "Dias desde a ultima coleta :" + last_collection
  element = find("th", text: str)
  expect(element).to_not be nil
end

Given(/^eu vejo que o limite de peso de resíduos é "([^"]*)" kg$/) do |limit_weight|
  str = "Limite de Peso: " + limit_weight
  element = find("th", text: str)
  expect(element).to_not be nil
end

Then(/^eu vejo que em "([^"]*)" dias precisarei fazer a licitação para a coleta$/) do |miss_days|
  str = "A próxima coleta deverá ser feita em " + miss_days + " dias"
  element = find("th", str)
  expect(element).to_not be nil
end

Given(/^eu vejo uma lista de "([^"]*)" com "([^"]*)" kg de "([^"]*)" no "([^"]*)" e "([^"]*)" kg de "([^"]*)" no "([^"]*)" e "([^"]*)" kg de "([^"]*)" no "([^"]*)"$/) do |list, res_weight1, res_name1, dep_name1, res_weight2, res_name2, dep_name2, res_weight3, res_name3, dep_name3|
  cad_col_gui(7500)
  cad_dep_gui(dep_name1)
  cad_dep_gui(dep_name2)
  cad_dep_gui(dep_name3)
  cad_lab_gui("Laboratorio de Genetica Aplicada", dep_name1)
  cad_lab_gui("Laboratorio de Processos Biotecnológicos", dep_name2)
  cad_lab_gui("Laboratorio de Microbiologia Clínica", dep_name3)
  name1 = res_name1 + dep_name1
  name2 = res_name2 + dep_name2
  name3 = res_name3 + dep_name3
  cad_res_gui(name1, "Laboratorio de Genetica Aplicada", "Líquido Inflamável")
  cad_reg_gui(res_weight1, res_name1)
  cad_res_gui(name2, "Laboratorio de Processos Biotecnológicos", "Sólido Inorgânico")
  cad_reg_gui(res_weight2, res_name2)
  cad_res_gui(name3, "Laboratorio de Microbiologia Clínica", "Outros")
  cad_reg_gui(res_weight3, res_name3)
  visit 'statistic'
  element = find("th", text: list)
  expect(element).to eq(list)
  expect(page).to have_content res_name1 + " Líquido Inflamável " + res_weight1 + " Laboratorio de Genetica Aplicada " + dep_name1
  expect(page).to have_content res_name2 + " Sólido Inorgânico " + res_weight2 + " Laboratorio de Processos Biotecnológicos " + dep_name2
  expect(page).to have_content res_name3 + " Outros " + res_weight3 + " Laboratorio de Microbiologia Clínica " + dep_name3
end

Then(/^eu vejo uma lista com o "([^"]*)" com "([^"]*)" kg para o "([^"]*)" e "([^"]*)" kg para o "([^"]*)"$/) do |list, res_weight1, dep_name1, res_weight2, dep_name2|
  element = find("th", text: list)
  expect(element).to_not be nil
  expect(page).to have_content dep_name1 + " " + res_weight1
  expect(page).to have_content dep_name2 + " " + res_weight2
  expect(page).to have_content dep_name3 + " " + res_weight3
end

Then(/^o sistema calcula a média de "([^"]*)" kg para o tipo "([^"]*)"$/) do |res_weight, res_type|
  validate_type(res_type, res_weight)
end

def validate_type(res_type, res_weight)
 case res_type
 when "Sólido Orgânico"
  expect(@collection.solido_organico_mean) == (res_weight.to_f())
 when "Sólido Inorgânico"
  expect(@collection.solido_inorganico_mean) == (res_weight.to_f())
 when "Líquido Orgânico"
  expect(@collection.liquido_organico_mean) == (res_weight.to_f())
 when "Líquido Inorgânico"
  expect(@collection.liquido_inorganico_mean) == (res_weight.to_f())
 when "Líquido Inflamável"
  expect(@collection.liquido_inflamavel_mean) == (res_weight.to_f())
 when "Outros"
  expect(@collection.outros_mean) == (res_weight.to_f())
 end
end

Then(/^o sistema calcula a média de "([^"]*)" kg para o "([^"]*)"$/) do |res_weight, dep_name|
  p @collection.dep_mean
  validate_dep(res_weight, dep_name)  
end

def validate_dep(res_weight, dep_name)
 expect(@collection.dep_mean[dep_name.parameterize.underscore.to_sym]).to eq(res_weight.to_f())
end
