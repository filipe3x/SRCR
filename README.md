#Registo de eventos numa instituicao de saude
Pequeno script em PROLOG com o intuito de simular uma base de dados de uma instituicao de saude

###Dependencias
    [sicstus](https://sicstus.sics.se) - interpretador de PROLOG
    
###Exemplos

% Identificar os serviços existentes numa instituição
servicosInstituicao(I, S) :- findall(X, servico(X, I), S).

% Identificar os utentes de uma instituição
utentesInstituicao(I, U) :- findall(X, recorreuInstituicao(X, I), U).

% Identificar os utentes de um determinado serviço
utentesServico(S, U) :- findall(X, recorreuServico(X, S), U).

% Identificar os utentes de um determinado serviço numa instituição
utentesServicoInstituicao(S,I,U) :- findall(X, registo(X, I, S), U).

% Identificar as instituições onde seja prestado um serviço
instituicoesComServico(S,I) :- findall(X, servico(S,X), I).

% Identificar as instituições onde seja prestado um conjunto de serviços
instituicoesComServicos([], []).
instituicoesComServicos([S | Tail], I) :- findall(X, servico(S, X), L1), instituicoesComServico(Tail, L2), concatenar(L1, L2, I).


Identificar os serviços existentes numa instituição

    | ?- servicosInstituicao(hospital_sao_marcos,S).
Output:

    S = [cardiologia,nutricionismo] ? 
    yes

Identificar os utentes de uma instituição

    | ?- utentesInstituicao(hospital_porto,U).
Output:

    U = [antonio_sousa,maria_meireles] ? 
    yes

Identificar os utentes de um determinado serviço

    | ?- utentesServico(geriatria,U).
Output:

    U = [maria_meireles] ? 
    yes

Identificar os utentes de um determinado serviço numa instituição

    | ?- utentesServicoInstituicao(cardiologia,hospital_sao_marcos,U).
Output:

    U = [antonio_sousa] ?  
    yes

Identificar as instituições onde seja prestado um serviço

    | ?- instituicoesComServico(cardiologia,I).
Output:

    I = [hospital_sao_marcos,hospital_braga,hospital_leiria,hospital_porto] ?
    yes

Identificar as instituições onde seja prestado um conjunto de serviços

    | ?- instituicoesComServicos([cirurgia,nutricionismo],I).
Output:

    I = [hospital_braga,hospital_lisboa] ? 
    yes
