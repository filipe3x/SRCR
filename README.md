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

####6) Identificar os serviços que não se podem encontrar numa instituição
Input:
    
    | ?- servicosNaoEncontrados(hospital_sao_marcos,S).

Output:
    
    S = [geriatria,neurologia,oncologia,cirurgia,clinica_geral,psiquiatria] ? 
    yes

####7) Determinar as instituições onde um profissional presta serviço 
Input:

    | ?- instituicoesProfissionalPrestaServico(filipe_oliveira,I).

Output:
    
    I = [hospital_porto,hospital_braga] ? 
    yes

#####8.0.1) Determinar todas as instituições a que um utente já recorreu
Input:
    
    | ?- utenteRecorreuInstituicao(maria_meireles,I).

Output:
    I = [hospital_porto] ?
    yes

#####8.0.2) Determinar todos os serviços a que um utente já recorreu 
Input:
    
    | ?- utenteRecorreuServico(maria_meireles,S).

Output:

    S = [geriatria] ?
    yes

#####8.0.3) Determinar todos os profissionais a que um utente já recorreu 
Input:
    
    | ?- utenteRecorreuProfissional(maria_meireles,P).

Output:

    P = [andre_santos] ? 
    yes

####8) Determinar todas as instituições (ou serviços, ou profissionais) a que um utente já recorreu 
Input:
    
    | ?- utenteRecorreu(maria_meireles,L).

Output:

    L = [hospital_porto,geriatria,andre_santos] ? 
    yes

####9) Registar utentes, profissionais, serviços, instituições e eventos médicos
#####9.0.1) Regitar utentes
Input:
    
    | ?- registarUtente(fernando_alvim).

Output:

    yes

#####9.0.2) Regitar instituicao
Input:
    
    | ?- registarInstituicao(hospital_luz).

Output:

    yes

#####9.0.3) Regitar serviço 
Input:
    
    | ?- registarServico(geriatria,hospital_luz).

Output:

    yes

#####9.0.4) Regitar profissional
Input:
    
    | ?- registarProfissional(filipe_marques,geriatria,hospital_luz).

Output:

    yes

#####9.0.5) Regitar evento médico
Input:
    
    | ?- registarEvento(fernando_alvim,filipe_marques,geriatria,hospital_luz).

Output:

    yes

####10) Remover utentes, profissionais, serviços, instituições
A remoção é análogamente inversa ao registo, ou seja, para cada registarXXX existe um removerXXX, p.e., para registarInstituicao(I) existe removerInstituicao(I).

