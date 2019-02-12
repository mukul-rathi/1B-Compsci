% modes ++ argument is ground, - is an output argument, ? Anything

% take(+ List, -H, - T)

take([H|T], H, T).
take([H|T], E, [H|R]) :- take(T, E, R).

% perm(+A, - B)
perm([],[]).
perm(L, [E|R]) :- take(L, E, S), perm(S, R).

% fixedPerm(+A, - B)

sameLength([],[]).
sameLength([_|T1], [_|T2]) :- sameLength(T1, T2).

fixedPerm([],[]).
fixedPerm(L, [E|R]) :- sameLength(L, [E|R]), take(L, E, S), fixedPerm(S, R).

