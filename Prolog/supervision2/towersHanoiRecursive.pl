%%%%% 28S.7

move(0, _, _, _, []) :- !.
move(N, S, T, A, Steps) :- N>0, N1 is N-1, move(N1, S, A, T, Steps1), move(N1,S,A, T, Steps2), append(Steps1, [mv(S,T)|Steps2], Steps).

solve(N, Steps) :- move(N, l1, l3, l2, Steps).


%%% diff lists

moveDif(0, _, _, _, A-A) :- !.
moveDif(N, S, T, A, Steps1-X) :- N>0, N1 is N-1, moveDif(N1, S, A, T, Steps1-[mv(S,T)|Steps2]), moveDif(N1,S,A, T, Steps2-X).

solveDif(N, Steps) :- moveDif(N, l1, l3, l2, Steps).

