%%%%%%%%%24S.1

not(A) :- A, !, fail.
not(_).

member([H|_], H).
member([_|T], H) :- member(T, H).

% come up with candidates for choose (note this will have repeated entries)
chooseCandidates(0, L, [], L):- !.
chooseCandidates(N, [H|T], [H|R], S) :- M is N-1, chooseCandidates(M, T, R, S).
chooseCandidates(N, [H|T], R, [H|S]) :- chooseCandidates(N, T, R, S).

% avoid duplicates
listOfChoose((N,L), A, Found) :- chooseCandidates(N,L, R,S), not(member(Found, (R,S))), not(member(Found, (S,R))), listOfChoose((N,L), A, [(R,S)|Found]), !.
listOfChoose(_, A, A).

take([H|T], H, T).
take([H|T], X, [H|R]) :- take(T, X, R).

choose(N, L, R, S):- listOfChoose((N,L), A, []), take(A, (R,S),_).

%%% my choose function still doesn't remove all duplicates - I can find more edge cases, however looking at the perm code, it doesn't generate unique permutations - so I think chooseCandidates is probably the choose function you're looking to mark.
%%% to fix this code I'd need an additional check - check that no permutations of R or S are members of Found to ensure uniqueness - perhaps there is a better way?