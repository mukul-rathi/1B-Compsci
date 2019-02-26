:- use_module(library(clpfd)).

notlate([]).
notlate([(S1, D1)|T]):- S1+D1 #=<100, notlate(T).

sequence([_]).
sequence([(S1, D1), (S2,D2)|T]) :- S1+D1 #=< S2, sequence([(S2,D2)|T]).

% take(+ List, -H, - T)

take([H|T], H, T).
take([H|T], E, [H|R]) :- take(T, E, R).

% perm(+A, - B)
perm([],[]).
perm(L, [E|R]) :- take(L, E, S), perm(S, R).


?- Tasks = [(Sv, 55), (E, 15), (Ls,5), (Lf, 10)],
    [Sv, E, Ls, Lf] ins 0..100,
    Ls+65 #=< Lf, notlate(Tasks), perm(Tasks, Order), sequence(Order), label([Sv, E, Ls, Lf]), print([Sv, E, Ls, Lf]), nl.