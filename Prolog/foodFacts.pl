% given list of facts, everything(A) = true if A is a list containing all X such that a(X) is true.

a(potatoes).
a(ham).
a(cheese).
a(eggs).

not(X) :- X, !, fail.
not(_).

member([H|_], H).
member([_|T], H) :- member(T, H).

%everything([X]) :- a(X).
%everything([A1, A2]) :- a(A1), a(A2), \+A1 = A2.

%everything([H|B], B) :- a(H), notMember(H, B).

everything(A, Found) :- a(X), not(member(Found,X)),!, everything(A, [X|Found]).
everything(A, A).
