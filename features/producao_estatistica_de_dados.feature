Feature: Produção Estatística de Dados
  As a usuário Administrador
  I want to ter acesso em tempo real a informações geradas pelo sistema referentes aos resíduos e departamentos
  So that posso ter acesso a resíduos acumulados, previsão de notificação de coleta.
  
@b1
Scenario: Sistema calcula previsão de coleta baseado em resíduos cadastrados
  Given existe "800" kg de residuos cadastrados no sistema
  And a ultima coleta foi feita a "10" dias
  And o limite de peso de residuos é "7500" kg
  When eu tento gerar a "Previsão de Notificação de Coleta"
  Then o sistema calcula a média de "80" kg/dia
  And o sistema calcula que faltam "6700" kg para atingir o limite
  And o sistema calcula que faltam "84" dias para fazer a licitação

@b2
Scenario: Gerar Dados de Total de Resíduos Acumulados por Tipo de Resíduo com resíduos cadastrados no sistema
  Given existe "800" kg de "Ácido Acético" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "300" kg de "Etanol" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "1200" kg de "Cal" de tipo "Sólido Inorgânico" cadastrado no sistema
  When eu tento gerar o "Total de Resíduos Acumulados por Tipo"
  Then o sistema calcula o  "Total de Resíduos Acumulados por Tipo" com "1100" kg de substâncias de tipo "Líquido Inflamável" e "1200" kg de substâncias de tipo "Sólido Inorgânico"
  
@b3
Scenario: Gerar a Notificação de Coleta sem resíduos cadastrados, GUI
  Given eu estou na página de estatistica
  And eu vejo a lista de "Resíduos Cadastrados" vazia
  When eu seleciono a opção "Gerar Previsão de Notificação de Coleta"
  Then eu vejo uma mensagem informando que não há resíduos cadastrados

@b4
Scenario: Gerar Dados de Total de Resíduos Acumulados por Tipo de Resíduo baseado em resíduos cadastrados no sistema, GUI
  Given eu estou na página de estatistica
  And eu vejo a lista de "Resíduos Cadastrados" 
  And eu vejo "800" kg de "Ácido Acético" de tipo "Líquido Inflamável" 
  And eu vejo "300" kg de "Etanol" de tipo "Líquido Inflamável" 
  And eu vejo "1200" kg de "Cal" de tipo "Sólido Inorgânico"
  When eu seleciono a opção "Gerar Total de Resíduos Acumulados por Tipo"
  Then eu vejo uma lista com o "Total de Resíduos Acumulados por Tipo" com  "1100" kg de substâncias de tipo "Líquido Inflamável" e "1200" kg de substâncias de tipo "Sólido Inorgânico"
  
@b5
Scenario: Gerar Porcentagem de Total de Resíduos Acumulados por Tipo de Resíduo com resíduos cadastrados no sistema
  Given existe "800" kg de "Ácido Acético" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "300" kg de "Etanol" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "1200" kg de "Cal" de tipo "Sólido Inorgânico" cadastrado no sistema
  When eu tento gerar o "Total de Resíduos Acumulados por Tipo em Porcentagem"
  Then o sistema calcula o  "Total de Resíduos Acumulados por Tipo em Porcentagem" com "47.83"% de substâncias de tipo "Líquido Inflamável" e "52.17"% de substâncias de tipo "Sólido Inorgânico"
   
@b6
Scenario: Gerar Dados Sobre o Resíduo Mais Frequentemente Cadastrado por Laboratorio baseado em resíduos cadastrados
  Given existe "900" kg de "Cal" no "Laboratorio de Ciência Forense" com "2" registros
  And existe "500" kg de "Ácido Acetico" no "Laboratorio de Ciência Forense" com "4" registros
  And existe "700" kg de "Álcool" no "Laboratorio de Química Organica" com "5" registros
  And existe "3000" kg de "Bromo" no "Laboratorio de Química Organica" com "2" registros
  And existe "500" kg de "Petróleo" no "Laboratorio de Química Organica" com "3" registros
  When eu tento gerar o "Resíduo Mais Frequentemente Cadastrado por Laboratorio"
  Then o sistema calcula o "Resíduo Mais Frequentemente Cadastrado por Laboratorio" com "Ácido Acetico" para o "Laboratorio de Ciência Forense" e com "Álcool" para o "Laboratorio de Química Organica"
  
@b7
Scenario: Gerar Poorcentagem de Total de Resíduos Acumulados por Tipo de Resíduo com resíduos cadastrados no sistema, GUI
  Given eu estou na página de estatistica
  And eu vejo a lista de "Resíduos Cadastrados" 
  And eu vejo "800" kg de "Ácido Acético" de tipo "Líquido Inflamável"
  And eu vejo "300" kg de "Etanol" de tipo "Líquido Inflamável"
  And eu vejo "1200" kg de "Cal" de tipo "Sólido Inorgânico"
  When eu seleciono a opção "Gerar Total de Resíduos Acumulados por Tipo em Porcentagem"
  Then eu vejo uma lista com o "Total de Resíduos Acumulados por Tipo em Porcentagem" com "47.83"% de substâncias de tipo "Líquido Inflamável" e "52.17"% de substâncias de tipo "Sólido Inorgânico"
  
@b8
Scenario: Gerar Dados Sobre o Resíduo Mais Frequentemente Cadastrado por Laboratorio baseado em resíduos cadastrados, GUI
  Given eu estou na página de estatistica
  And eu vejo a lista de "Resíduos Cadastrados"
  And eu vejo "900" kg de "Cal" no "Laboratorio de Ciência Forense" com "2" registros
  And eu vejo "500" kg de "Ácido Acetico" no "Laboratorio de Ciência Forense" com "4" registros
  And eu vejo "700" kg de "Álcool" no "Laboratorio de Química Organica" com "5" registros
  And eu vejo "3000" kg de "Bromo" no "Laboratorio de Química Organica" com "2" registros
  And eu vejo "500" kg de "Petróleo" no "Laboratorio de Química Organica" com "3" registros
  When eu seleciono a opção "Gerar Resíduo Mais Frequentemente Cadastrado por Laboratorio"
  Then eu vejo a lista "Resíduo Mais Frequentemente Cadastrado por Laboratorio" com "Ácido Acetico" para o "Laboratorio de Ciência Forense" e com "Álcool" para o "Laboratorio de Química Organica"
  
@b9
Scenario: Gerar Dados de Total de Resíduos Acumulados por Departamento baseado em resíduos cadastrados
  Given que o "Departamento de Antibióticos" e o "Departamento de Anatomia Humana" estão cadastrados no sistema
  And que "300" kg de "Ácido Acético" estão no "Departamento de Antibióticos"
  And que "100" kg de "Cal" estão no "Departamento de Antibióticos"
  And que "500" kg de "Cal" estão no "Departamento de Anatomia Humana"
  When eu tento gerar o "Total de Resíduos Acumulados por Departamento"
  Then o sistema calcula o "Total de Resíduos Acumulados por Departamento" com "500" kg para o "Departamento de Anatomia Humana" e "400" kg para o "Departamento de Antibióticos"  
  
@b10
Scenario: Calcular Quantidade Média de Resíduos Cadastrados baseado em resíduos cadastrados no sistema
  Given existe "1500" kg de residuos cadastrados no sistema
  And a ultima coleta foi feita a "10" dias
  When eu tento calcular a "Quantidade Média de Resíduos Cadastrados"
  Then o sistema calcula a média de "150" kg/dia

@b11
Scenario: Previsão de Notificação de Coleta baseado em resíduos armazenados, GUI
  Given eu estou na página de estatistica
  And eu vejo a lista de "Resíduos Cadastrados"
  And eu vejo que o total de resíduos armazenados é "1200" kg
  And eu vejo que a última coleta foi feita a "10" dias
  And eu vejo que o limite de peso de resíduos é "7500" kg
  When eu seleciono a opção "Gerar Previsão de Notificação de Coleta"
  Then eu vejo que em "53" dias precisarei fazer a licitação para a coleta

@b12
Scenario: Gerar Dados de Total de Resíduos Acumulados por Departamento baseado em resíduos cadastrados, GUI
  Given eu estou na página de estatistica
  And eu vejo uma lista de "Resíduos Cadastrados" com "500" kg de "Ácido Acético" no "Departamento de Anatomia Humana" e "300" kg de "Ácido Acético" no "Departamento de Antibióticos" e "1200" kg de "Cal" no "Departamento de Anatomia Humana"
  When eu seleciono a opção "Gerar Total de Resíduos Acumulados por Departamento"
  Then eu vejo uma lista com o "Total de Resíduos Acumulados por Departamento" com "1700" kg para o "Departamento de Anatomia Humana" e "300" kg para o "Departamento de Antibióticos"
  
@b13
Scenario: Calcular a Média de Resíduos Cadastrados por Tipo baseado em resíduos cadastrados
  Given existe "800" kg de "Ácido Acético" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "300" kg de "Etanol" de tipo "Líquido Inflamável" cadastrado no sistema
  And existe "1200" kg de "Cal" de tipo "Sólido Inorgânico" cadastrado no sistema
  When eu tento calcular a "Quantidade Média de Resíduos Cadastrados por Tipo"
  Then o sistema calcula a média de "550" kg para o tipo "Líquido Inflamável"
  And o sistema calcula a média de "1200" kg para o tipo "Sólido Inorgânico"
  
@b14
Scenario: Calcular a Média de Resíduos Cadastrados por Departamento baseado em resíduos cadastrados
 Given que o "Departamento de Antibióticos" e o "Departamento de Anatomia Humana" estão cadastrados no sistema
  And que "300" kg de "Ácido Acético" estão no "Departamento de Antibióticos"
  And que "100" kg de "Cal" estão no "Departamento de Antibióticos"
  And que "500" kg de "Cal" estão no "Departamento de Anatomia Humana"
  When eu tento calcular a "Quantidade Média de Resíduos Cadastrados por Departamento"
  Then o sistema calcula a média de "200" kg para o "Departamento de Antibióticos"
  And o sistema calcula a média de "500" kg para o "Departamento de Anatomia Humana"
  
@b15
Scenario: Calcular a Média de Resíduos Cadastrados por Tipo baseado em resíduos armazenados, GUI
  Given eu estou na página de estatistica
  And eu vejo a lista de "Resíduos Cadastrados"
  And eu vejo "800" kg de "Ácido Acético" de tipo "Líquido Inflamável" 
  And eu vejo "300" kg de "Etanol" de tipo "Líquido Inflamável"
  And eu vejo "1200" kg de "Cal" de tipo "Sólido Inorgânico"
  When eu seleciono a opção "Quantidade Média de Resíduos Cadastrados por Tipo"
  Then eu vejo uma lista da "Quantidade Média de Resíduos Cadastrados por Tipo" com "550" kg para o tipo "Líquido Inflamável" e "1200" kg para o tipo "Sólido Inorgânico"
  