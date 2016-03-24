
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
:- dynamic registo/4.

% Base de Conhecimento sobre Utentes --------------------------------------------------------------------------------------------

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
servico(cirurgia, hospital_lisboa).

servico(clinica_geral, hospital_braga).
servico(clinica_geral, hospital_porto).

servico(psiquiatria, hospital_braga).

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

recorreuInstituicao(U, I) :- registo(U,I,_,_).
recorreuServico(U, S) :- registo(U,_,S,_).
recorreuProfissional(U, P) :- registo(U,_,_,P).

todosProfissionais(P) :- profissional(P,_,_).
profissionaisNoServico(S,P) :- profissional(P,S,_).
profissionaisNaInstituicao(I,P) :- profissional(P,_,I).

% Queries a base de conhecimento -------------------------------------------------------------------------------------------------

% 1) Extensao do predicado Identificar os serviços existentes numa instituição
% servicosInstituicao(Instituicao,Servicos) -> {V,F}
servicosInstituicao(Instituicao,Servicos) :- solucoes(X, servico(X, Instituicao), Servico).

% 2) Extensao do predicado Identificar os utentes de uma instituição
% utentesInstituicao(Instituicao,Utentes) -> {V,F}
utentesInstituicao(Instituicao,Utentes) :- solucoes(X, recorreuInstituicao(X, Instituicao), Utentes).

% 3) Extensao do predicado Identificar os utentes de um determinado serviço
% utentesServico(Servico,Utentes) -> {V,F}
utentesServico(Servico,Utentes) :- solucoes(X, recorreuServico(X, Servico), Utentes).

% 4) Extensao do predicado Identificar os utentes de um determinado serviço numa instituição
% utentesServicoInstituicao(Servico,Instituicao,Utente) -> {V,F}
utentesServicoInstituicao(Servico,Institiocao,Utente) :- solucoes(X, registo(X, Instituicao, Servico), Utente).

% 5) Extensao do predicado Identificar as instituições onde seja prestado um serviço ou um conjunto de servicos
% instituicaoesComServico(Servico,Instituicao) -> {V,F}
% instituicoesComServicos([Servicos],Instituicao) -> {V,F}
instituicoesComServicos([], []).
instituicoesComServicos(Servico,Instituicao) :- solucoes(X, servico(Servico,X), Instituicao).
instituicoesComServicos([Servico | Tail], Instituicao) :- 
  solucoes(X, servico(Servico, X), L1),
  instituicoesComServicos(Tail, L2),
  concatenar(L1, L2, Instituicao).

% 6) Extensao do predicado Identificar os serviços que não se podem encontrar numa instituição
% servicosNaoEncontrados(Instituicao,[Servicos]) -> {V,F}
servicosNaoEncontrados(Instituicao, Servicos) :-
  solucoes(X, servico(X, Y), L1),
  removerduplicados(L1, R1),
  solucoes(X, servico(X, Instituicao), L2),
  intercepcao(L2, R1, R2),
  removerduplicados(R2, Servicos).

% 7) Extensao do predicado Determinar as instituições onde um profissional presta serviço
% instituicoesProfissionalPrestaServico(Professional, [Instituicoes] ) -> {V,F}
instituicoesProfissionalPrestaServico(Profissional, Instituicoes ) :-
  solucoes(X,profissional(Profissional,_,X),L1),
  removerduplicados(L1,Instituicoes).

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
utenteRecorreuProfissional(U,Profissionais) :- 
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

% 9) Registar utentes, profissionais, serviços ou instituições

% 10) Remover utentes (ou profissionais ou serviços ou instituições) dos registos

% Invariantes -------------------------------------------------------------------------------------------------------------------
%
% Invariante Estrutural: 
%   nao permitir a insercao de conhecimento repetido sobre:
%   - utente (utentes distintos nao teem o mesmo nome)
+utente(Nome)::(solucoes(Nome,(utente(Nome)),S),
          comprimento(S,N),
                  N==1).
%   - instituicao (instituicoes distintas nao teem o mesmo nome)

%   - servico ( servicos distintos do mesmo hospital nao teem o mesmo nome)

%   - profissional ( profissionais distintos nao teem o mesmo nome )


% Invariante Referencial:
%

% Predicados que permitem evolução do conhecimento ------------------------------------------------------------------------------ 

% Extensão do predicado que permite a evolucao do conhecimento
% disponibilizada pelo professor na aula prática da semana5
evolucao( Termo ) :- solucoes(Invariante,+Termo::Invariante,Lista),
inserir(Termo),
testar(Lista).

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

% Funcoes sobre listas ----------------------------------------------------------------------------------------------------------

% Extensao do meta-predicado nao : Questao -> {V,F}
nao(Questao) :- Questao, !, fail.
nao(Questao).

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

