% PROTOTIPOS DAS QUERIES
% ...
% ...


% PROTOTIPOS DAS FUNCOES AUX SOBRE LISTAS
% ...
% ...

% SICStus PROLOG: Declaracoes iniciais
:- set_prolog_flag( unknown,fail ).
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).


% SICStus PROLOG: Definicoes iniciais
% permitida a evolução sobre utentes, profissionais, serviços ou instituições

:- op( 900,xfy,'::' ).
:- dynamic utente/1.
:- dynamic profissional/3.
:- dynamic servico/2.
:- dynamic instituicao/1.

% Base de Conhecimento sobre Utentes --------------------------------------------------------------------------------------------

utente(antonio_sousa).
utente(antonio_marques).
utente(maria_meireles).
utente(diamantino_marques).
utente(delfina_araujo).
utente(jorge_marques).
utente(rosa_sousa).


% Base de Conhecimento sobre Registo de entradas --------------------------------------------------------------------------------

registo(antonio_sousa, hospital_sao_marcos, cardiologia).
registo(antonio_sousa, hospital_sao_marcos, cardiologia).
registo(antonio_sousa, hospital_sao_marcos, nutricionismo).
registo(antonio_sousa, hospital_porto, nutricionismo).
registo(maria_meireles, hospital_porto, geriatria).
registo(maria_meireles, hospital_porto, geriatria).
registo(maria_meireles, hospital_porto, geriatria).
registo(maria_meireles, hospital_porto, geriatria).
registo(maria_meireles, hospital_porto, geriatria).
registo(maria_meireles, hospital_porto, geriatria).

recorreuInstituicao(U, I) :- registo(U,I,_).
recorreuServico(U, S) :- registo(U,_,S).
recorreuProfissional(U, P) :- registo(U,I,S), profissional(P,S,I).


% Base de Conhecimento sobre Instituições ---------------------------------------------------------------------------------------

instituicao(hospital_sao_marcos).
instituicao(hospital_braga).
instituicao(hospital_lisboa).
instituicao(hospital_porto).
instituicao(hospital_leiria).


% Base de Conhecimento sobre Serviços -------------------------------------------------------------------------------------------

servico(cardiologia, hospital_sao_marcos).
servico(cardiologia, hospital_braga).
servico(cardiologia, hospital_leiria).
servico(cardiologia, hospital_porto).
servico(nutricionismo, hospital_sao_marcos).
servico(nutricionismo, hospital_braga).
servico(nutricionismo, hospital_leiria).
servico(nutricionismo, hospital_porto).
servico(geriatria, hospital_porto).
servico(neurologia, hospital_porto).
servico(oncologia, hospital_porto).
servico(cirurgia, hospital_braga).
servico(clinica_geral, hospital_braga).
servico(cirurgia, hospital_lisboa).
servico(psiquiatria, hospital_braga).

% Base de Conhecimento sobre Profissionais --------------------------------------------------------------------------------------

profissional(salvador_sousa, oncologia, hospital_porto).
profissional(luis_sousa, clinica_geral, hospital_braga).
profissional(tiago_sousa, cirurgia, hospital_lisboa).
profissional(andreia_goncalves, cirurgia, hospital_braga).
profissional(vanessa_goncalves, cardiologia, hospital_sao_marcos).
profissional(marta_caetano, nutricionismo, hospital_sao_marcos).

todosProfissionais(P) :- profissional(P,_,_).
profissionaisNoServico(S,P) :- profissional(P,S,_).
profissionaisNaInstituicao(I,P) :- profissional(P,_,I).


% Funcoes sobre listas ----------------------------------------------------------------------------------------------------------

% Negacao
not(P) :- P, !, fail.
not(_).

% Verifica se elemento existe dentro de uma lista de elementos
pertence(X,[X | _ ]).
pertence(X,[ _ | XS]) :- pertence(X,XS).

% Nr de elementos existentes numa lista 
comprimento([],0).
comprimento([ _ | XS], L) :- 
	comprimento(XS,L1),
	L is L1 + 1.

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
concatenar(L1, [], L1).
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


% Queries a base de conhecimento -------------------------------------------------------------------------------------------------
%% FALTA ELIMINAR RESULTADOS REPETIDOS

% Extensao do predicado Identificar os serviços existentes numa instituição
% servicosInstituicao(I,S) -> {V,F}
servicosInstituicao(I, S) :- findall(X, servico(X, I), S).

% Extensao do predicado Identificar os utentes de uma instituição
% utentesInstituicao(I,U) -> {V,F}
utentesInstituicao(I, U) :- findall(X, recorreuInstituicao(X, I), U).

% Extensao do predicado Identificar os utentes de um determinado serviço
% utentesServico(S,U) -> {V,F}
utentesServico(S, U) :- findall(X, recorreuServico(X, S), U).

% Extensao do predicado Identificar os utentes de um determinado serviço numa instituição
% utentesServicoInstituicao(S,I,U) -> {V,F}
utentesServicoInstituicao(S,I,U) :- findall(X, registo(X, I, S), U).

% Extensao do predicado Identificar as instituições onde seja prestado um serviço
% instituicaoesComServico(S,I) -> {V,F}
instituicoesComServico(S,I) :- findall(X, servico(S,X), I).

% Extensao do predicado Identificar as instituições onde seja prestado um conjunto de serviços
% instituicoesComServicos([S],I) -> {V,F}
instituicoesComServicos([], []).
instituicoesComServicos([S | Tail], I) :- findall(X, servico(S, X), L1), instituicoesComServico(Tail, L2), concatenar(L1, L2, I).

% Extensao do predicado Identificar os serviços que não se podem encontrar numa instituição
% servicosNaoEncontrados(I,S) -> {V,F}
servicosNaoEncontrados(I, S) :- 
	findall(X, servico(X, Y), L1), 
	removerduplicados(L1, R1),
	findall(X, servico(X, I), L2), 
	intercepcao(L2, R1, R2), 
	removerduplicados(R2, S).

% Extensao do predicado Determinar as instituições onde um profissional presta serviço
% listarProfissionaisNaInstituicao(I,P) -> {V,F}
listarProfissionaisNaInstituicao(I,P) :- findall(X, profissionaisNaInstituicao(I,X), P).

% Extensao do predicado Determinar todas as instituições (ou serviços ou profissionais) a que um utente já recorreu
% utenteRecorreuInstituicao(U,I) -> {V,F}
utenteRecorreuInstituicao(U,I) :- findall(X, recorreuInstituicao(U,X), I).

% Extensao do predicado Determinar todas as instituições (ou serviços ou profissionais) a que um utente já recorreu
% utenteRecorreuServico(U,S) -> {V,F}
utenteRecorreuServico(U,S) :- findall(X, recorreuServico(U,X), S).
utenteRecorreuProfissional(U,P) :- findall(X, recorreuProfissional(U,X), P).

% Registar utentes, profissionais, serviços ou instituições
% ...
registar(Q).

% Remover utentes (ou profissionais ou serviços ou instituições) dos registos
% ...
remover(Q).


%Queries extra ------------------------------------------------------------------------------------------------------------------
% ...


% Invariantes -------------------------------------------------------------------------------------------------------------------
% Invariante Estrutural 
% Invariante Referencial 
%

% Predicados que permitem evolução do conhecimento ------------------------------------------------------------------------------ 

% Extensão do predicado que permite a evolucao do conhecimento
% disponibilizada pelo professor na aula prática da semana5
evolucao( Termo ) :- solucoes(I,+Termo::I,Li),
 inserir(Termo),
 testar(Li).

% predicado disponibilizado pelo professor na semana5
% testar: Li -> {V,F}.
testar([]).
testar([I,L]):-I,testar(L).

% predicado disponibilizado pelo professor na semana5
% inserir: T -> {V,F}
inserir(T):-assert(T).
inserir(T):-retract(T),!,fail.

% predicado disponibilizado pelo professor na semana5
% solucoes X,Y,Z -> {V,F}
solucoes(X,Y,Z):-findall(X,Y,Z).

comprimento(S,N):-length(S,N).

