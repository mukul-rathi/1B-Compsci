%state(L, M, R) - lists consisting of rings on each peg, pegs - numbered 1,2,3.


not(A) :- A, !, fail.
not(_).
member([H|_], H).
member([_|T], H) :- member(T, H).


start(state([1,2,3],[],[])).
finish(state([],[],[1,2,3])).

valid([]).
valid([X]).
valid([H1, H2 |T]):- H1 =< H2, valid([H2|T]).

route(state([H|T],M,R), state(T, [H|M], R)) :- valid([H|M]).

route(state([H|T],M,R), state(T,M, [H|R])) :-valid([H|R]).

route(state(L,[H|T],R), state([H|L],T,R)) :- valid([H|L]).
route(state(L,[H|T],R), state(L,T,[H|R])) :- valid([H|R]).

route(state(L,M,[H|T]), state([H|L],M,T)) :- valid([H|L]).
route(state(L,M,[H|T]), state(L,[H|M],T)) :- valid([H|M]).



travelSafeLog(A, A,_, [A]) :- finish(A).
travelSafeLog(A,C, Closed, [A| Steps]) :- route(A, B), not(member(Closed, B)), travelSafeLog(B,C, [B|Closed],Steps).

solve(R) :- start(A), finish(B), travelSafeLog(A, B,[],R).