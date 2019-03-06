%%%% 28S.8

filter([], [], _).
filter([H|T], [H|R], H) :- !,filter(T, R, H).
filter([_|T], R, H) :- !,filter(T, R, H).

dutchFlag(L, R):- filter(L, R1, red), filter(L, R2, white), filter(L, R3, blue), append(R1, R2, S), append(S, R3, R).

%%% rewrite with diffLists

filterDif([], A-A, _).
filterDif([H|T], [H|R]-X, H) :- !,filterDif(T, R-X, H).
filterDif([_|T], R-X, H) :- !,filterDif(T, R-X, H).

dutchFlagDif(L, R1-X):- filterDif(L, R1-R2, red), filterDif(L, R2-R3, white), filterDif(L, R3-X, blue).