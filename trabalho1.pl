%Identificar os serviços existentes numa instituição;
% servico: Servico, Instituicao -> {V, F}

%Identificar os utentes de uma instituição;
% recorreuInstituicao: Utente, Instituicao -> {V, F}
%% falta eliminar resultados repetidos

%Identificar os utentes de um determinado serviço;
% recorreuServico: Utente, Servico -> {V, F}

%Identificar os utentes de um determinado serviço numa instituição;
% registo: Utente, Instituicao, Servico -> {V, F}
%% falta eliminar resultados repetidos

%Identificar as instituições onde seja prestado um dado serviço ou conjunto de serviços;
% servico: Servico, Instituicao -> {V, F}
%% falta listar para conjunto de servicos

%Identificar os serviços que não se podem encontrar numa instituição;
% falta este

%Determinar as instituições onde um profissional presta serviço;
% listarProfissionaisNoServico: Servico, Profissional -> {V, F}

%Determinar todas as instituições (ou serviços, ou profissionais) a que um utente já recorreu;
%recorreuInstituicao: Utente, Instituicao -> {V, F}
%recorreuServico: Utente, Servico -> {V, F}
%recorreuProfissional: Utente, Profissional -> {V, F}

%Registar utentes, profissionais, serviços ou instituições;
% falta este

%Remover utentes (ou profissionais, ou serviços, ou instituições) dos registos.
% falta este

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

% Base de Conhecimento sobre Utentes -------------------------------------------------------------------------------------------

utente(antonio_sousa).
utente(filipe_marques).
utente(antonio_marques).
utente(maria_meireles).
utente(diamantino_marques).
utente(delfina_araujo).
utente(jorge_marques).
utente(rosa_sousa).

%falta
adicionarUtente.
removerUtente.

% Base de Conhecimento sobre Registo de entradas -------------------------------------------------------------------------------

registo(antonio_sousa, hospital_sao_marcos, cardiologia).
registo(antonio_sousa, hospital_sao_marcos, cardiologia).
registo(antonio_sousa, hospital_sao_marcos, nutricionismo).
registo(maria_meireles, ipo_porto, gereatria).

recorreuInstituicao(U, I) :- registo(U,I,_).
recorreuServico(U, S) :- registo(U,_,S).
recorreuProfissional(U, P) :- registo(U,I,S), profissional(P,S,I).

%falta
adicionarRegisto.
removerRegisto.

% Base de Conhecimento sobre Instituições --------------------------------------------------------------------------------------

instituicao(hospital_sao_marcos).
instituicao(hospital_braga).
instituicao(hospital_lisboa).
instituicao(ipo_porto).

%falta
adicionarInstituicao.
removerInstituicao.

% Base de Conhecimento sobre Serviços ------------------------------------------------------------------------------------------

servico(cardiologia, hospital_sao_marcos).
servico(nutricionismo, hospital_sao_marcos).
servico(gereatria, ipo_porto).
servico(neurologia, ipo_porto).
servico(oncologia, ipo_porto).
servico(cirurgia, hospital_braga).
servico(clinica_geral, hospital_braga).
servico(cirurgia, hospital_lisboa).
servico(psiquiatria, hospital_braga).

servicosNaoPrestados(I, S) :- not(servico(S, I)).

servicos_instituicao(I, S) :- findall(X, servico(X, I), S).

%falta
adiconarServico.
removerServico.

% Base de Conhecimento sobre Profissionais -------------------------------------------------------------------------------------

profissional(salvador_sousa, oncologia, ipo_porto).
profissional(luis_sousa, clinica_geral, hospital_braga).
profissional(tiago_sousa, cirurgia, hospital_lisboa).
profissional(andreia_goncalves, cirurgia, hospital_braga).
profissional(vanessa_goncalves, cardiologia, hospital_sao_marcos).
profissional(marta_caetano, nutricionismo, hospital_sao_marcos).

listarProfissionais(P) :- profissional(P,_,_).
listarProfissionaisNoServico(S,P) :- profissional(P,S,_).
listarProfissionaisNaInstituicao(I,P) :- profissional(P,_,I).

%falta
adicionarProfessional.
removerProfessional.

% Funcoes sobre listas ---------------------------------------------------------------------------------------------------------

%Negacao
not(P) :- P, !, fail.
not(_).

%Verifica se elemento existe dentro de uma lista de elementos
pertence(X,[X | _ ]).
pertence(X,[ _ | XS]) :- pertence(X,XS).

%Nr de elementos existentes numa lista 
comprimento([],0).
comprimento([ _ | XS], L) :- 
	comprimento(XS,L1),
	L is L1 + 1.

%Apaga a primeira ocurrencia de um elemento numa lista
apagar(X, [X | XS], XS).
apagar(E, [X | XS], [X | YS]) :- apagar(E, XS, YS).

%Apaga todas as ocurrencias de um elemento numa lista
apagartudo(_, [], []).
apagartudo(X,[X | XS], YS) :- apagartudo(X,XS,YS).
apagartudo(E,[X | XS], [X | YS]) :- apagartudo(E, XS, YS).

%Insere elemento a cabeca da lista, caso ainda nao exista
adicionar(X, L, L) :- pertence(X,L).
adicionar(X, L, [X | L]).

%Concatenacao da lista L1 com lista L2
concatenar([], L2, L2).
concatenar(L1, [], L1).
concatenar([X | L1], L2, [X | R]) :- concatenar(L1, L2, R).

%Inverte ordem dos elementos de uma lista
inverter([X],[X]).
inverter([X | XS], L2) :- inverter(XS, YS), concatenar(YS,[X],L2).

%Verifica se S e sublista de L
sublista(S,L) :- concatenar(S,_,L).
sublista(S,L) :- concatenar(_,S,L).
sublista(S, [ _ | YS]) :- 
	sublista(S, YS).

%Remove elementos duplicados de uma lista
removerduplicados([],[]).
removerduplicados([H|T],C) :- pertence(H,T),!, removerduplicados(T,C).
removerduplicados([H|T],[H|C]) :- removerduplicados(T,C).

%Faltam invariantes ---------------------------------------------------------------
% ...
% ...
