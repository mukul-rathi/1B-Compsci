% given list of facts, everything(A) = true if A is a list containing all X such that a(X) is true.

a(ham).
a(cheese).
a(eggs).

not(X) :- X, !, fail.
not(_).

notMember(_, []).
notMember(X, [X| T]) :- !, fail.
notMember(X, [A, T]) :- notMember(X, T).

everything([X]) :- a(X).
everything([A1, A2]]) :- a(A1), a(A2), \+A1 = A2.
everything([H|B], B) :- a(H), notMember(H, B).

everything(A, Found) :- a(X), notMember(X,A),!, everything(A, [X|Found]).
everything(A, A).
