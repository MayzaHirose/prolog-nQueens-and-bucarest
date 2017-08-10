% Mayza Yuri Hirose da Costa RA88739
% Tadao Hara RA89935

:- use_module(library(plunit)).

:- begin_tests(retira_membro).
test(retira_membro1) :- retira_membro(1,[1,2,3],[2,3]).
test(retira_membro2, YS == [2,3]) :- retira_membro(1,[1,2,3], YS).
:- end_tests(retira_membro).

:- begin_tests(nao_membro).
test(nao_membro1) :- nao_membro(1,[2,3]).
test(nao_membro2, YS == []) :- nao_membro(1,YS).
:- end_tests(nao_membro).

:- begin_tests(elementos_distintos).
test(elementos_distintos1) :- elementos_distintos([1,2,3]).
test(elementos_distintos2, [fail]) :- elementos_distintos([1,1,2,3]).
:- end_tests(elementos_distintos).

:- begin_tests(valido_diagonal_cima).
test(valido_diagonal_cima1) :- valido_diagonal_cima(1,[2,3]).
test(valido_diagonal_cima2, [fail]) :- valido_diagonal_cima(1,[1,2,3]).
:- end_tests(valido_diagonal_cima).

:- begin_tests(valido_diagonal_baixo).
test(valido_diagonal_baixo1) :- valido_diagonal_baixo(1,[2,3]).
test(valido_diagonal_baixo2, [fail]) :- valido_diagonal_baixo(1,[1,2,3]).
:- end_tests(valido_diagonal_baixo).


% ------------------- VERSÃO GERAR E TESTAR COM PERMUTAÇÕES -------------------

%% rainhas_p(?Q, +N) is nondet.
%  Verdadeiro se Q é uma solução de tamanho N com N rainhas.
%  Este predicado constrói as possíves soluções do N-rainhas.
rainhas_p(Q, N) :-
	sequencia(1, N, R),
	permutacao(R, Q),
	solucao(Q).


%% sequencia(+I, +F, ?S) is semidet.
%  Verdadeiro se S é uma lista com os números inteiros entre I % e
%  F(inclusive).
sequencia(F, F, S) :-
	S = [F],
	!.

sequencia(I, F, S) :-
	I0 is I+1,
	sequencia(I0, F, S0),
	S = [I|S0].


%% permutacao(?L, ?P) is nondet.
%  Verdadeiro se P é uma permutação da lista L
permutacao([],[]).

permutacao(L, [P|PS]) :-
	retira_membro(P,L,L1),
	permutacao(L1,PS).

%% retira_membro(+X, +XS, ?YS) is nondet.
%  Verdadeiro se YS é a lista XS mas sem a ocorrência de X.
%  Exemplo:
%    ?- retira_membro(1, [1,2,3], YS).
%    YS = [2,3].
retira_membro(X, [X | XS], L1) :-
	L1 = XS.

retira_membro(X, [Y | YS], L1) :-
	retira_membro(X, YS, L2),
	L1 = [Y|L2].



%% -------------------------- VERSÃO COM BACKTRACKING --------------------------

% rainhas_n(?Q, +N) is nondet.
% predicado "interface" para o rainhas/3
rainhas_n(Q, N) :-
	rainhas_n(Q, N, N).


%% rainhas_n(?Q, +N, +T) is nondet.
%  Verdadeiro se Q é uma solução de tamanho T com N rainhas.
%  Este é um predicado auxiliar e não deve ser chamado diretamente.
%  Sua prova deve ser realizada com N = T.
%  Exemplo:
%    ?- rainhas_n(Q, 5, 5).
%    Q = [4, 2, 5, 3, 1] ;
%    Q = [3, 5, 2, 4, 1] ;
%    Q = [5, 3, 1, 4, 2] ;
%    ...
rainhas_n([R|Rs], N, T) :-
	T > 0, !,
	T0 is T-1,
	rainhas_n(Rs, N, T0),
	entre(1, N, R),
	solucao([R|Rs]).

rainhas_n([], _, 0).



%% entre(+I, +F, ?V) is nondet.
%  Verdadeiro se V é um número natural entre I e F (inclusive).
%  Exemplo:
%    ?- entre(1, 3, V).
%    V = 1;
%    V = 2;
%    V = 3;
%    false.
entre(I,F,V):-
	I < F,
	V = I.

entre(F,F,V):-
	!,
	V = F.

entre(I,F,V):-
	I < F,
	I0 is I+1,
	entre(I0,F,V).

%% solucao(+Q) is semidet.
%  Verdadeiro se Q é uma solução N-rainhas
%  Este predicado apenas verifica se Q é uma solução, e não a constrói.
%  Exemplo:
%    ?- solucao([4, 5, 3, 2, 1]).
%    true.
solucao([Q1|QS]):-
	elementos_distintos([Q1|QS]),
	Q0 is Q1-1,
	valido_diagonal_cima(Q0, QS),
	Q2 is Q1+1,
	valido_diagonal_baixo(Q2, QS),
	solucao(QS).

solucao([_]):-!.

%% nao_membro(+X, +XS) is det.
%  Verdadeiro se XS é uma lista sem a ocorrência de X.
%  Exemplo:
%    ?- nao_membro(1, [1,2,3]).
%    false.
%    ?- nao_membro(1, [2,3]).
%    true.
nao_membro(_, []):-
	!.

nao_membro(X, [Y | XS]) :-
	X =\= Y,
	nao_membro(X, XS).

%% elementos_distintos(+XS) is det.
%  Verdadeiro se XS é uma lista sem repeticoes
%  Exemplo:
%    ?- elementos_distintos([1,2,3]).
%    true.
%    ?- elementos_distintos([1,1,2,3]).
%    false.
elementos_distintos([]).

elementos_distintos([A|AS]):-
	nao_membro(A, AS),
	elementos_distintos(AS).

%% valido_diagonal_cima(+X, +XS) is det.
%  Verdadeiro se XS possui a diagonal de cima livre em relacao a X.
%  Verifica recursivamente se, em relacao à rainha atual, haverá uma
%  rainha na sua diagonal mais para frente.
%
%  Exemplo:
%    ?- valido_diagonal_cima(1,[2,3]).
%    true.
%    ?- valido_diagonal_cima(1,[1,2,3]).
%    false.
valido_diagonal_cima(Q0,[Q|QS]):-
	Q =\= Q0,
	Q1 is Q0-1,
	valido_diagonal_cima(Q1,QS), !.

valido_diagonal_cima(_,[]).

%% valido_diagonal_baixo(+X, +XS) is det.
%  Verdadeiro se XS possui a diagonal de baixo livre em relacao a X.
%  Verifica recursivamente se, em relacao à rainha atual, haverá uma
%  rainha na sua diagonal mais para frente.
%
%  Exemplo:
%    ?- valido_diagonal_baixo(1,[2,3]).
%    true.
%    ?- valido_diagonal_baixo(1,[1,2,3]).
%    false.
valido_diagonal_baixo(Q0,[Q|QS]):-
	Q =\= Q0,
	Q1 is Q0+1,
	valido_diagonal_baixo(Q1,QS), !.

valido_diagonal_baixo(_,[]).

