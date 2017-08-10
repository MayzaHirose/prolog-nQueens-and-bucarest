% Mayza Yuri Hirose da Costa RA88739
% Tadao Hara RA89935

:- use_module(library(plunit)).

:- begin_tests(menor_custo).
test(menor_custo1, V ==	arad) :- menor_custo([d(arad, 75), d(oradea, 71)], V).
test(menor_custo2, V == urziceni) :- menor_custo([d(iasi, 92), d(urziceni, 142)], V).
test(menor_custo2, V == rimnicu_vilcea) :- menor_custo([d(arad, 140), d(fagaras, 99), d(oradea, 151), d(rimnicu_vilcea, 80)], V).
:- end_tests(menor_custo).

vizinhos(arad, [d(sibiu,140), d(timisoara,118), d(zerind,75)]).
vizinhos(bucharest, [d(fagaras,211), d(giurgiu,90), d(pitesti,101), d(urziceni,85)]).
vizinhos(craiova, [d(dobreta,120), d(pitesti,138), d(rimnicu_vilcea,146)]).
vizinhos(dobreta, [d(craiova,120), d(mehadia,75)]).
vizinhos(eforie, [d(hirsova,86)]).
vizinhos(fagaras, [d(bucharest,211), d(sibiu,99)]).
vizinhos(giurgiu, [d(bucharest,90)]).
vizinhos(hirsova, [d(eforie,86), d(urziceni, 98)]).
vizinhos(iasi, [d(neamt, 87), d(vaslui, 92)]).
vizinhos(lugoj, [d(mehadia, 70), d(timisoara, 111)]).
vizinhos(mehadia, [d(dobreta, 75), d(lugoj, 70)]).
vizinhos(neamt, [d(iasi, 87)]).
vizinhos(oradea, [d(sibiu, 151), d(zerind, 71)]).
vizinhos(pitesti, [d(bucharest, 101), d(craiova, 138), d(rimnicu_vilcea, 97) ]).
vizinhos(rimnicu_vilcea, [d(craiova, 146), d(pitesti, 97), d(sibiu, 80)]).
vizinhos(sibiu, [d(arad, 140), d(fagaras, 99), d(oradea, 151), d(rimnicu_vilcea, 80)]).
vizinhos(timisoara, [d(arad, 118), d(lugoj, 111)]).
vizinhos(urziceni, [d(bucharest, 85), d(hirsova, 98), d(vaslui, 142)]).
vizinhos(vaslui, [d(iasi, 92), d(urziceni, 142)]).
vizinhos(zerind, [d(arad, 75), d(oradea, 71)]).

heuristica(arad, 366).
heuristica(bucharest, 0).
heuristica(craiova, 160).
heuristica(dobreta, 238).
heuristica(eforie, 161).
heuristica(fagaras, 178).
heuristica(giurgiu, 77).
heuristica(hirsova, 151).
heuristica(iasi, 226).
heuristica(lugoj, 244).
heuristica(mehadia, 241).
heuristica(neamt, 234).
heuristica(oradea, 380).
heuristica(pitesti, 98).
heuristica(rimnicu_vilcea, 193).
heuristica(sibiu, 253).
heuristica(timisoara, 329).
heuristica(urziceni, 80).
heuristica(vaslui, 199).
heuristica(zerind, 374).

%% melhor_caminho(?O, ?C) is nondet
%  Verdadeiro se C é o melhor caminho entre O e bucharest
%  Exemplo:
%    ?- melhor_caminho(sibiu, C).
%    C = [sibiu, rimnicu_vilcea, pitesti, bucharest].
melhor_caminho(bucharest, [bucharest]) :- !.
melhor_caminho(O, [O|Cs]) :-
	melhor_vizinho(O, V), !,
	melhor_caminho(V, Cs).


%% melhor_vizinho(?O, ?V) is nondet
%  Verdadeiro se V é o melhor vizinho de O
%  Exemplo:
%    ?- melhor_vizinho(sibiu, V).
%    V = rimnicu_vilcea.
melhor_vizinho(O, V) :-
	vizinhos(O,OS),
	menor_custo(OS, V).

%% menor_custo(?Vizinhos, ?Menor_cidade) is det
%  Verdadeiro se Menor_cidade é a cidade com menor custo dentre os
%  Vizinhos
%  Exemplo: ?- menor_custo([d(arad, 75), d(oradea, 71)], V).
%	    V = arad.
%	    ?- menor_custo([d(iasi, 92), d(urziceni, 142)], V).
%	    V = urziceni.
menor_custo([O|OS], Menor_cidade) :-
	O = d(Cidade,Dist),
	heuristica(Cidade,H),
	Custo is Dist+H,
	Menor is Custo,
	menor_custo(OS, Menor, Cidade, Cidade0),
	Menor_cidade = Cidade0, !.

menor_custo([O|OS], Menor, _, Menor_cidade2) :-
	O = d(Cidade,Dist),
	heuristica(Cidade,H),
	Custo is Dist+H,
	Menor > Custo,
	Menor0 is Custo,
	menor_custo(OS, Menor0, Cidade, Menor_cidade0),
	Menor_cidade2 = Menor_cidade0.

menor_custo([_|OS], Menor, Menor_cidade, Menor_cidade0) :-
	menor_custo(OS, Menor, Menor_cidade, Menor_cidade0).

menor_custo([], _, Cidade, Cidade0):-
	Cidade0 = Cidade.


