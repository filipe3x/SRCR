
% SICStus PROLOG: Declaracoes iniciais
%:- set_prolog_flag( unknown,fail ).
%:- set_prolog_flag( discontiguous_warnings,off ).
%:- set_prolog_flag( single_var_warnings,off ).

% SICStus PROLOG: Definicoes iniciais
% permitida a evolucao sobre utentes, profissionais, servicos, instituicoes, registos de actividade medica

:- op(900,xfy,'::').
:- dynamic utente/1.
:- dynamic profissional/3.
:- dynamic servico/2.
:- dynamic instituicao/1.
:- dynamic registo/4.

%% Invariantes -------------------------------------------------------------------------------------------------------------------
%  >>>>> Invariantes para operacao de adicao <<<<<
%
%   - utente:
%        Invariante Estrutural:
%           - utentes distintos nao teem o mesmo nome
+utente(Utente)::(
  solucoes( (Utente), ( utente(Utente) ), Lista),
  comprimento(Lista,N),
  N==1
  ).

%   - instituicao:
%        Invariante Estrutural:
%           - instituicoes distintas nao teem o mesmo nome
+instituicao(Instituicao)::(
  solucoes( (Instituicao), ( instituicao(Instituicao) ), Lista),
  comprimento(Lista,N),
  N==1
  ).

%   - servico:
%        Invariante Estrutural:
%           - servicos distintos da mesma instituicao nao teem o mesmo nome
%        Invariante Referencial:
%           - a instituicao associada ao servico existe
+servico(Servico,Instituicao)::(
  solucoes( (Servico,Instituicao) , ( servico(Servico,Instituicao) ), Lista),
  comprimento(Lista,N),
  N==1,
  solucoes( (Instituicao) , ( instituicao(Instituicao) ), ListaInst),
  comprimento(ListaInst,NInst),
  NInst==1
  ).

%   - profissional:
%        Invariante Estrutural:
%           - profissionais distintos nao teem o mesmo nome 
%        Invariante Referencial:
%           - a instituicao a ele associada existe
%           - o servico a ele associado existe na instituicao a ele associado
+profissional(Profissional,Servico,Instituicao)::(
  solucoes( (Profissional), ( profissional(Profissional,Servico,Instituicao) ), Lista),
  comprimento(Lista,N),
  N==1,
  solucoes( (Instituicao) , ( instituicao(Instituicao) ), ListaInst),
  comprimento(ListaInst,NInst),
  NInst==1,
  solucoes( (Servico,Instituicao) , ( servico(Servico,Instituicao) ), ListaServ),
  comprimento(ListaServ,NServ),
  NServ==1
  ).

%   - registo:
%        Invariante Estrutural:
%           - tem que existir pelo menos um registo com essas caracteristicas depois da insercao
%        Invariante Referencial:
%           - o utente a ele associado existe
%           - a instituicao a ele associado existe
%           - o servico a ele associado existe na instituicao a ele associado
%           - o profissional associado ao registo esta associado ao servico e instituicao
+registo(Utente,Instituicao,Servico,Profissional)::(
  solucoes( (Utente,Instituicao,Servico,Profissional), ( registo(Utente,Instituicao,Servico,Profissional) ), Lista),
  comprimento(Lista,N),
  N>=1,
  solucoes( (Utente), ( utente(Utente) ), ListaUten),
  comprimento(ListaUten,NUten),
  NUten==1,
  solucoes( (Instituicao) , ( instituicao(Instituicao) ), ListaInst),
  comprimento(ListaInst,NInst),
  NInst==1,
  solucoes( (Servico,Instituicao) , ( servico(Servico,Instituicao) ), ListaServ),
  comprimento(ListaServ,NServ),
  NServ==1,
  solucoes( (Profissional,Servico,Instituicao), ( profissional(Profissional,Servico,Instituicao) ), ListaProf),
  comprimento(ListaProf,NProf),
  NProf==1
  ).

%  >>>>> Invariantes para operacao de remocao <<<<<
%   - utente:
%        Invariante Estrutural:
%           - nao pode existir o utente depois da operacao de remocao
%        Invariante Referencial:
%           - utentes apenas podem ser eliminado se nao existirem registos a ele associado
-utente(Utente)::(
  solucoes( (Utente), ( utente(Utente) ), Lista),
  comprimento(Lista,N),
  N==0,
  solucoes( (Utente,_,_,_), ( registo(Utente,_,_,_) ), ListaReg),
  comprimento(ListaReg,NReg),
  NReg==0
  ).

%   - instituicao:
%        Invariante Estrutural:
%           - nao pode existir a instituicao depois da operacao de remocao
%        Invariante Referencial:
%           - instituicoes apenas pode ser eliminadas se nao exitirem registos a ela associada
%           - instituicoes apenas pode ser eliminadas se nao exitirem servicos a ela associada
%           - instituicoes apenas pode ser eliminadas se nao exitirem profissionais a ela associada
-instituicao(Instituicao)::(
  solucoes( (Instituicao), ( instituicao(Instituicao) ), Lista),
  comprimento(Lista,N),
  N==0,
  solucoes( (_,Instituicao,_,_), ( registo(_,Instituicao,_,_) ), ListaReg),
  comprimento(ListaReg,NReg),
  NReg==0,
  solucoes( (_,Instituicao) , ( servico(_,Instituicao) ), ListaServ),
  comprimento(ListaServ,NServ),
  NServ==0,
  solucoes( (_,_,Instituicao), ( profissional(_,_,Instituicao) ), ListaProf),
  comprimento(ListaProf,NProf),
  NProf==0
  ).

%   - servico:
%        Invariante Estrutural:
%           - nao pode existir o servico depois da operacao de remocao 
%        Invariante Referencial:
%           - servicos apenas podem ser eliminados se nao exitirem registos a ele associados
%           - servicos apenas podem ser eliminados se nao exitirem profissionais a ele associados
-servico(Servico,Instituicao)::(
  solucoes( (Servico,Instituicao) , ( servico(Servico,Instituicao) ), Lista),
  comprimento(Lista,N),
  N==0,
  solucoes( (_,Instituicao,Servico,_), ( registo(_,Instituicao,Servico,_) ), ListaReg),
  comprimento(ListaReg,NReg),
  NReg==0,
  solucoes( (_,Servico,Instituicao), ( profissional(_,Servico,Instituicao) ), ListaProf),
  comprimento(ListaProf,NProf),
  NProf==0
  ).

%   - profissional:
%        Invariante Estrutural:
%           - nao pode existir o profissional depois da operacao de remocao 
%        Invariante Referencial:
%           - profissionais apenas podem ser eliminados se nao exitirem registos a ele associados
-profissional(Profissional,Servico,Instituicao)::(
  solucoes( (Profissional), ( profissional(Profissional,Servico,Instituicao) ), Lista),
  comprimento(Lista,N),
  N==0,
  solucoes( (_,Instituicao,Servico,Profissional), ( registo(_,Instituicao,Servico,Profissional) ), ListaReg),
  comprimento(ListaReg,NReg),
  NReg==0
  ).

%% Base de Conhecimento sobre Utentes --------------------------------------------------------------------------------------------

utente(antonio_sousa).
utente(antonio_marques).
utente(maria_meireles).
utente(diamantino_marques).
utente(delfina_araujo).
utente(jorge_marques).
utente(rosa_sousa).

% Base de Conhecimento sobre Instituições ---------------------------------------------------------------------------------------

instituicao(hospital_sao_marcos).
instituicao(hospital_braga).
instituicao(hospital_lisboa).
instituicao(hospital_porto).
instituicao(hospital_leiria).

% Base de Conhecimento sobre Serviços -------------------------------------------------------------------------------------------

servico(cardiologia,hospital_sao_marcos).
servico(cardiologia,hospital_braga).
servico(cardiologia,hospital_leiria).
servico(cardiologia,hospital_porto).

servico(nutricionismo,hospital_sao_marcos).
servico(nutricionismo,hospital_braga).
servico(nutricionismo,hospital_leiria).
servico(nutricionismo,hospital_porto).

servico(geriatria,hospital_porto).

servico(neurologia,hospital_porto).

servico(oncologia,hospital_porto).

servico(cirurgia,hospital_braga).
servico(cirurgia,hospital_lisboa).

servico(clinica_geral,hospital_braga).
servico(clinica_geral,hospital_porto).

servico(psiquiatria,hospital_braga).

% Base de Conhecimento sobre Profissionais --------------------------------------------------------------------------------------

profissional(salvador_sousa, oncologia, hospital_porto).
profissional(filipe_oliveira, nutricionismo, hospital_porto).
profissional(filipe_marques, nutricionismo, hospital_porto).
profissional(filipe_oliveira, clinical_geral, hospital_porto).
profissional(filipe_marques, clinical_geral, hospital_porto).
profissional(luis_mendes, clinica_geral, hospital_porto).
profissional(andre_santos, geriatria, hospital_porto).

profissional(tiago_sousa, cirurgia, hospital_lisboa).

profissional(vanessa_goncalves, cardiologia, hospital_sao_marcos).
profissional(marta_caetano, nutricionismo, hospital_sao_marcos).

profissional(filipe_oliveira, nutricionismo, hospital_braga).
profissional(filipe_marques, nutricionismo, hospital_braga).
profissional(luis_mendes, nutricionismo, hospital_braga).
profissional(luis_mendes, clinical_geral, hospital_braga).
profissional(luis_sousa, clinica_geral, hospital_braga).
profissional(andreia_goncalves, cirurgia, hospital_braga).

% Base de Conhecimento sobre Registo de entradas --------------------------------------------------------------------------------

registo(antonio_sousa, hospital_sao_marcos, cardiologia, vanessa_goncalves).
registo(antonio_sousa, hospital_sao_marcos, cardiologia, vanessa_goncalves).
registo(antonio_sousa, hospital_sao_marcos, nutricionismo, filipe_oliveira).
registo(antonio_marques, hospital_porto, nutricionismo, filipe_marques).
registo(maria_meireles, hospital_porto, geriatria, andre_santos).
registo(maria_meireles, hospital_porto, geriatria, andre_santos).
registo(diamantino_marques, hospital_porto, geriatria, andre_santos).
registo(diamantino_marques, hospital_porto, geriatria, andre_santos).
registo(rosa_sousa, hospital_porto, geriatria, andre_santos).
registo(jorge_marques, hospital_porto, geriatria, andre_santos).

% Predicados Extra ---------------------------------------------------------------------------------------------------------------
% predicados criados com o intuito de facilitar as queries 'a base de conhecimento

recorreuInstituicao(Utente, Instituicao) :- registo(Utente,Instituicao,_,_).
recorreuServico(Utente, Servico) :- registo(Utente,_,Servico,_).
recorreuProfissional(Utente, Profissional) :- registo(Utente,_,_,Profissional).

todosProfissionais(Profissional) :- profissional(Profissional,_,_).
profissionaisNoServico(Servico,Profissional) :- profissional(Profissional,Servico,_).
profissionaisNaInstituicao(Instituicao,Profissional) :- profissional(Profissional,_,Instituicao).

% E1) Extensao do predicado que permite determinar o numero de utentes de uma instituicao 
% quantosUtentesInstituicao(Instituicao,NumeroUtentes) -> {V,F}
quantosUtentesInstituicao(Instituicao,NumeroUtentes) :- 
  utentesInstituicao(Instituicao,ListaUtentes),
  comprimento(ListaUtentes,NumeroUtentes).

% E2.0.1) Extensao do predicado dada uma lista de instituicoes determina a lista de utilizacao em numero de utentes para cada instituicao 
%listaUtilizacaoInstituicoes( [I],  [[I,N]]) -> {V,F}
listaUtilizacaoInstituicoes( [I],  [[I,N]]) :- 
  quantosUtentesInstituicao(I,N).
listaUtilizacaoInstituicoes( [I|TAIL_INST],  [[I,N] | XS]) :- 
  quantosUtentesInstituicao(I,N),
  listaUtilizacaoInstituicoes(TAIL_INST,XS).

% E2) Extensao do predicado que permite determinar a lista de utilizacao em numero de utentes de todas as instituicoes na base de conhecimento 
%utilizacaoInstituicoes(ListaUtilizacao) -> {V,F} 
mapaUtilizacaoInstituicoes(ListaUtilizacao) :- 
  solucoes( (Instituicao),( instituicao(Instituicao) ), ListaInstituicoes),
  listaUtilizacaoInstituicoes(ListaInstituicoes,ListaUtilizacao).

% E3) Extensao do predicado que permite determinar o numero de eventos medicos de um utente 
% quantosEventosUtente(Utente,NumeroEventos) -> {V,F}
quantosEventosMedicosUtente(Utente,NumeroEventos) :-
  eventosMedicosUtente(Utente,ListaEventosMedicos),
  comprimento(ListaEventosMedicos,NumeroEventos).

% E3.0.1) Extensao do predicado que permite identificar todos os eventos medicos de um utente 
eventosMedicosUtente(Utente,ListaEventosMedicos) :-
  solucoes( (Utente), ( registo(Utente,_,_,_) ), ListaEventosMedicos).

% E4.0.1) Extensao do predicado dada uma lista de utentes determina a lista do numero de eventos medicos para cada utentes 
%listaEventosMedicosUtente( [Utentes],  [[Utente,N]]) -> {V,F}
listaEventosMedicosUtente( [Utente],  [[Utente,N]]) :- 
  quantosEventosMedicosUtente(Utente,N).
listaEventosMedicosUtente( [Utente|TAIL_UT],  [[Utente,N] | XS]) :- 
  quantosEventosMedicosUtente(Utente,N),
  listaEventosMedicosUtente(TAIL_UT,XS).

% E4) Extensao do predicado que permite determinar a lista de numero de eventos medicos por utente de todos os utentes na base de conhecimento 
%mapaEventosMedicosUtentes(ListaEventos) -> {V,F} 
mapaEventosMedicosPorUtente(ListaEventosUtente) :- 
  solucoes( (Utente),( utente(Utente) ), ListaUtentes),
  listaEventosMedicosUtente(ListaUtentes,ListaEventosUtente).

% E5) Extensao do predicado que permite determinar o numero de eventos medicos em que um profissional esteve envolvido 
% quantosEventosMedicosProfissional(Profissional,NumeroEventos) -> {V,F}
quantosEventosMedicosProfissional(Profissional,NumeroEventos) :-
  eventosMedicosProfissional(Profissional,ListaEventosMedicos),
  comprimento(ListaEventosMedicos,NumeroEventos).

% E5.0.1) Extensao do predicado que permite identificar todos os eventos medicos de um profissional 
eventosMedicosProfissional(Profissional,ListaEventosMedicos) :-
  solucoes( (Profissional), ( registo(_,_,_,Profissional) ), ListaEventosMedicos).

% E6.0.1) Extensao do predicado dada uma lista de profissionais determina a lista do numero de eventos medicos em que cada um esteve envolvido 
%listaEventosMedicosProfissional( [Profissionais],  [[Profissional,N]]) -> {V,F}
listaEventosMedicosProfissional( [Profissional],  [[Profissional,N]]) :- 
  quantosEventosMedicosProfissional(Profissional,N).
listaEventosMedicosProfissional( [Profissional|TAIL_PF],  [[Profissional,N] | XS]) :- 
  quantosEventosMedicosProfissional(Profissional,N),
  listaEventosMedicosProfissional(TAIL_PF,XS).

% E6) Extensao do predicado que permite determinar a lista de numero de eventos medicos por utente de todos os profissionais na base de conhecimento 
%mapaEventosMedicosPorProfissional(ListaEventosProfissional) -> {V,F} 
mapaEventosMedicosPorProfissional(ListaEventosProfissional) :- 
  solucoes( (Profissional),( profissional(Profissional,_,_) ), ListaProfissionaisRep),
  removerduplicados(ListaProfissionaisRep, ListaProfissionais),
  listaEventosMedicosProfissional(ListaProfissionais,ListaEventosProfissional).

% E7) Extensao do predicado que permite determinar o numero de eventos medicos em que um servico esteve envolvido 
% quantosEventosMedicosServico(Servico,NumeroEventos) -> {V,F}
quantosEventosMedicosServico(Servico,NumeroEventos) :-
  eventosMedicosServico(Servico,ListaEventosMedicos),
  comprimento(ListaEventosMedicos,NumeroEventos).

% E7.0.1) Extensao do predicado que permite identificar todos os eventos medicos de um servico
eventosMedicosServico(Servico,ListaEventosMedicos) :-
  solucoes( (Servico), ( registo(_,_,Servico,_) ), ListaEventosMedicos).

% E8.0.1) Extensao do predicado dada uma lista de servicos determina a lista do numero de eventos medicos em que cada um esteve envolvido 
%listaEventosMedicosServico( [Servicos],  [[Servico,N]]) -> {V,F}
listaEventosMedicosServico( [Servico],  [[Servico,N]]) :- 
  quantosEventosMedicosServico(Servico,N).
listaEventosMedicosServico( [Servico|TAIL_SERV],  [[Servico,N] | XS]) :- 
  quantosEventosMedicosServico(Servico,N),
  listaEventosMedicosServico(TAIL_SERV,XS).

% E8) Extensao do predicado que permite determinar a lista de numero de eventos medicos por servico de todos os servicos na base de conhecimento 
%mapaEventosMedicosPorServico(ListaEventosServico) -> {V,F} 
mapaEventosMedicosPorServico(ListaEventosServico) :- 
  solucoes( (Servico),( servico(Servico,_) ), ListaServicosRep),
  removerduplicados(ListaServicosRep, ListaServicos),
  listaEventosMedicosServico(ListaServicos,ListaEventosServico).

% Queries a base de conhecimento -------------------------------------------------------------------------------------------------

% 1) Extensao do predicado Identificar os servicos existentes numa instituicao
% servicosInstituicao(Instituicao,Servicos) -> {V,F}
servicosInstituicao(Instituicao,Servicos) :- solucoes(X, servico(X, Instituicao), Servicos).

% 2) Extensao do predicado Identificar os utentes de uma instituição
% utentesInstituicao(Instituicao,ListaUtentes) -> {V,F}
utentesInstituicao(Instituicao,ListaUtentes) :-
  solucoes(X, recorreuInstituicao(X, Instituicao), ListaUtentesRep),
  removerduplicados(ListaUtentesRep, ListaUtentes).

% 3) Extensao do predicado Identificar os utentes de um determinado serviço
% utentesServico(Servico,ListaUtentes) -> {V,F}
utentesServico(Servico,ListaUtentes) :-
  solucoes(X, recorreuServico(X, Servico), ListaUtentesRep),
  removerduplicados(ListaUtentesRep,ListaUtentes).

% 4) Extensao do predicado Identificar os utentes de um determinado serviço numa instituição
% utentesServicoInstituicao(Servico,Instituicao,ListaUtentes) -> {V,F}
utentesServicoInstituicao(Servico,Instituicao,ListaUtentes) :-
  solucoes( (Utente) , (registo(Utente, Instituicao, Servico,_) ), ListaUtentesRep),
  removerduplicados(ListaUtentesRep,ListaUtentes).

% 5) Extensao do predicado Identificar as instituicoes onde seja prestado um servico ou um conjunto de servicos
% instituicoesComServicos(Servico,Instituicao) -> {V,F}
% instituicoesComServicos([Servicos],Instituicao) -> {V,F}
instituicoesComServicos([ ],_).
instituicoesComServicos(Servico,ListaInstituicoes) :- solucoes((Instituicao), (servico(Servico,Instituicao)), ListaInstituicoes).
instituicoesComServicos([Servico | TailServicos], ListaInstituicoes) :-
  solucoes( (Instituicao),(servico(Servico,Instituicao)), ListaInst1),
  instituicoesComServicos(TailServicos, ListaInst2),
  concatenar(ListaInst1, ListaInst2, ListaInstituicoes).


% 6) Extensao do predicado Identificar os servicos que nao se podem encontrar numa instituicao
% servicosNaoEncontrados(Instituicao,[Servicos]) -> {V,F}
servicosNaoEncontrados(Instituicao, ListaServicosNaoEncontrados) :-
  solucoes(Servico, servico(Servico, _), L1),
  removerduplicados(L1, ListaServicosTotal),
  solucoes(Servico, servico(Servico, Instituicao), ListaServicosInst),
  intercepcao(ListaServicosInst, ListaServicosTotal, R2),
  removerduplicados(R2, ListaServicosNaoEncontrados).

% 7) Extensao do predicado Determinar as instituicoes onde um profissional presta servico
% instituicoesProfissionalPrestaServico(Professional, [Instituicoes] ) -> {V,F}
instituicoesProfissionalPrestaServico(Profissional,ListaInstituicoes) :-
  solucoes((Instituicao),profissional(Profissional,_,Instituicao),ListaInstituicoesDupl),
  removerduplicados(ListaInstituicoesDupl,ListaInstituicoes).

% 8.0.1) Extensao do predicado Determinar todas as instituições a que um utente já recorreu
% utenteRecorreuInstituicao(Utente,[Instituicoes]) -> {V,F}
utenteRecorreuInstituicao(Utente,Instituicoes) :- 
  solucoes(X, recorreuInstituicao(Utente,X), InstituicoesComDupl),
  removerduplicados(InstituicoesComDupl, Instituicoes).

% 8.0.2) Extensao do predicado Determinar todos os serviços a que um utente já recorreu
% utenteRecorreuServico(Utente,[Servicos]) -> {V,F}
utenteRecorreuServico(Utente,Servicos) :- 
  solucoes(X, recorreuServico(Utente,X), ServicosComDupl),
  removerduplicados(ServicosComDupl, Servicos).

% 8.0.3) Extensao do predicado Determinar todos os profissionais a que um utente já recorreu
%utenteRecorreuProfissional(Utente,[Profissionais]) -> {V,F}
utenteRecorreuProfissional(Utente,Profissionais) :- 
  solucoes(X, recorreuProfissional(Utente,X), ProfissionaisComDupl),
  removerduplicados(ProfissionaisComDupl, Profissionais).

% 8) Extensao do predicado Determinar todas as instituições (ou serviços, ou profissionais) a que um utente já recorreu
% utenteRecorreu(Utente,Lista) -> {V,F}
utenteRecorreu(Utente,Lista) :-
  utenteRecorreuInstituicao(Utente,LInst),
  utenteRecorreuServico(Utente,LServ),
  utenteRecorreuProfissional(Utente,LProf),
  concatenar(LInst, LServ, LInstServ),
  concatenar(LInstServ,LProf,Lista).

% 9) Extensao do predicado Registar utentes, profissionais, serviços ou instituições

% Extensao do predicado que pemite registar utentes
% registarUtente(Nome) -> {V,F}
registarUtente(Nome) :- evolucao(utente(Nome)).

% Extensao do predicado que pemite registar instituicoes
% registarInstituicao(Instituicao) -> {V,F}
registarInstituicao(Instituicao) :- evolucao(instituicao(Instituicao)).

% Extensao do predicado que pemite registar servicos numa instituicao
% registarServico(Servico,Instituicao) -> {V,F}
registarServico(Servico,Instituicao) :- evolucao(servico(Servico,Instituicao)).

% Extensao do predicado que pemite registar profissionais num determinado servico de numa instituicao
% registarProfissional(Profissional,Servico,Instituicao) -> {V,F}
registarProfissional(Profissional,Servico,Instituicao) :- evolucao(profissional(Profissional,Servico,Instituicao)).

% Extensao do predicado que pemite registar eventos medicos numa instituicao indicando o utente, o profissional, o servico e a instituicao
% registarEvento(Utente,Profissional,Servico,Instituicao) -> {V,F}
registarEvento(Utente,Profissional,Servico,Instituicao) :- evolucao(registo(Utente,Profissional,Servico,Instituicao)).

% 10) Remover utentes (ou profissionais ou serviços ou instituições) dos registos

% Extensao do predicado que pemite remover utentes
% removerUtente(Nome) -> {V,F}
removerUtente(Nome) :- remocao(utente(Nome)).

% Extensao do predicado que pemite remover instituicoes
% removerInstituicao(Instituicao) -> {V,F}
removerInstituicao(Instituicao) :- remocao(instituicao(Instituicao)).

% Extensao do predicado que pemite remover servicos numa instituicao
% registarServico(Servico,Instituicao) -> {V,F}
removerServico(Servico,Instituicao) :- remocao(servico(Servico,Instituicao)).

% Extensao do predicado que pemite remover profissionais num determinado servico de numa instituicao
% removerProfissional(Profissional,Servico,Instituicao) -> {V,F}
removerProfissional(Profissional,Servico,Instituicao) :- remocao(profissional(Profissional,Servico,Instituicao)).

% Extensao do predicado que pemite remover eventos medicos numa instituicao indicando o utente, o profissional, o servico e a instituicao
% removerEvento(Utente,Profissional,Servico,Instituicao) -> {V,F}
removerEvento(Utente,Profissional,Servico,Instituicao) :- remocao(registo(Utente,Profissional,Servico,Instituicao)).

% Predicados que permitem evolução do conhecimento ------------------------------------------------------------------------------ 

% Extensão do predicado que permite a evolucao do conhecimento
% disponibilizada pelo professor na aula prática da semana5
evolucao( Termo ):-solucoes(Invariante,+Termo::Invariante,Lista),
inserir(Termo),
testar(Lista).

% predicado disponibilizado pelo professor na semana5
% inserir: T -> {V,F}
inserir(Termo):-assert(Termo).
inserir(Termo):-retract(Termo),!,fail.

% predicado disponibilizado pelo professor na semana5
% testar: Li -> {V,F}.
testar([]).
testar([I|L]):-I,testar(L).

% Extensão do predicado que permite a remocao do conhecimento
% remocao(Termo) -> {V,F}
remocao( Termo ):-solucoes(Invariante,-Termo::Invariante,Lista),
remover(Termo),
testar(Lista).

% remover: T -> {V,F}
remover(Termo):-retract(Termo).
remover(Termo):-assert(Termo),!,fail.

% predicado disponibilizado pelo professor na semana5
% solucoes X,Y,Z -> {V,F}
solucoes(X,Y,Z):-findall(X,Y,Z).

% Funcoes sobre listas ----------------------------------------------------------------------------------------------------------

% Extensao do meta-predicado nao : Questao -> {V,F}
nao(Questao) :- Questao, !, fail.
nao(_).

% Verifica se elemento existe dentro de uma lista de elementos
pertence(X,[X | _ ]).
pertence(X,[ _ | XS]) :- pertence(X,XS).

% Nr de elementos existentes numa lista 
comprimento([],0).
comprimento([_ | L],R) :- comprimento(L,N),R is N+1.

% Apaga a primeira ocurrencia de um elemento numa lista
apagar(X, [X | XS], XS).
apagar(E, [X | XS], [X | YS]) :- apagar(E, XS, YS).

% Apaga todas as ocurrencias de um elemento numa lista
apagartudo(_, [], []).
apagartudo(X,[X | XS], YS) :- apagartudo(X,XS,YS).
apagartudo(E,[X | XS], [X | YS]) :- apagartudo(E, XS, YS).

% Insere elemento a cabeca da lista, caso ainda nao exista
adicionar(X, L, L) :- pertence(X,L).
adicionar(X, L, [X | L]).

% Concatenacao da lista L1 com lista L2
concatenar([], L2, L2).
concatenar([X | L1], L2, [X | R]) :- concatenar(L1, L2, R).

% Inverte ordem dos elementos de uma lista
inverter([X],[X]).
inverter([X | XS], L2) :- inverter(XS, YS), concatenar(YS,[X],L2).

% Verifica se S e sublista de L
sublista(S,L) :- concatenar(S,_,L).
sublista(S,L) :- concatenar(_,S,L).
sublista(S, [ _ | YS]) :- 
  sublista(S, YS).

% Remove elementos duplicados de uma lista
removerduplicados([],[]).
removerduplicados([H|T],C) :- pertence(H,T), !, removerduplicados(T,C).
removerduplicados([H|T],[H|C]) :- removerduplicados(T,C).

% Subtrai elementos de L1 a L2, produzindo L3
intercepcao([], L, L).
intercepcao([H | Tail], L2, L3) :- apagar(H, L2, R), intercepcao(Tail, R, L3).

