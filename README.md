#Registo de eventos numa instituicao de saude
Pequeno script em PROLOG com o intuito de simular uma base de dados de uma instituicao de saude

###Dependencias
[sicstus](https://sicstus.sics.se) - interpretador de PROLOG

###Instrucoes

Carregar script

    | ?- [trabalho1].
Para sair

    | ?- halt.

###Exemplos

####1) Identificar os serviços existentes numa instituição
Input:
    | ?- servicosInstituicao(hospital_sao_marcos,S).

Output:
    S = [cardiologia,nutricionismo] ? 
    yes

####2) Identificar os utentes de uma instituição
Input:
    | ?- utentesInstituicao(hospital_porto,U).

Output:
    U = [antonio_sousa,maria_meireles] ? 
    yes

####3) Identificar os utentes de um determinado serviço
Input:
    | ?- utentesServico(geriatria,U).

Output:
    U = [maria_meireles] ? 
    yes

####4) Identificar os utentes de um determinado serviço numa instituição
Input:
    | ?- utentesServicoInstituicao(cardiologia,hospital_sao_marcos,U).

Output:
    U = [antonio_sousa] ?  
    yes

####5) Identificar as instituições onde seja prestado um dado serviço ou conjunto de serviços
Input:
    | ?- instituicoesComServico(cardiologia,I).

Output:
    I = [hospital_sao_marcos,hospital_braga,hospital_leiria,hospital_porto] ?
    yes

Input:
    | ?- instituicoesComServicos([cirurgia,nutricionismo],I).

Output:
    I = [hospital_braga,hospital_lisboa] ? 
    yes

