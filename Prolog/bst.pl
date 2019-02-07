% representation of a tree
% br(L, V, R).
% lf.

% how to insert - note our implicit definition of the tree made explicit in the comments

insert(N, lf, br(lf, N, lf)).
insert(N, br(L,C,R), br(P,C,R)) :- N =<C, insert(N, L, P).
insert(N, br(L,C,R), br(L, C, P)) :- N > C, insert(N, R, P).

equals(X, Y) :- helper(X, Y, X2, Y2).
helper(X,Y, X2, Y2):- X2 is X, Y2 is Y, X2=Y2.

unify(A,A). % implement equality (=)
