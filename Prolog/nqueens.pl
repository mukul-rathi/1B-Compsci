nQueens(N, R) :- rangeNums(N, L), perm(L, R), checkDiagonals(R).

rangeNums(0, []):- !.
rangeNums(N, L) :- N>=1, M is N-1, rangeNums(M, L1), append(L1, [N], L).  

take([H|T], H, T).
take([H|T], E, [H|R]) :- take(T, E, R).

perm([],[]).
perm(L, [E|R]) :- take(L, E, S), perm(S, R).

checkDiagonals([]).
checkDiagonals([H|T]) :- checkUpDiag(T, H), checkDownDiag(T,H), checkDiagonals(T).

checkUpDiag([], _).
checkUpDiag([H|T], X) :- Y is X+1, H=\=Y, checkUpDiag(T, Y).

checkDownDiag([], _).
checkDownDiag([H|T], X) :- Y is X-1, H=\=Y, checkDownDiag(T, Y).