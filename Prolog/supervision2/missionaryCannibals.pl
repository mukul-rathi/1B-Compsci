% state = #missionaries on left, # cannibals on left, #boat side (l/r).

not(A) :- A, !, fail.
not(_).
member([H|_], H).
member([_|T], H) :- member(T, H).

state(3,3,_).
state(3,2,_).
state(3,1,_).
state(3,0,_).

state(2,2,_).

state(1,1,_).

state(0,0,_).
state(0,1,_).
state(0,2,_).
state(0,3,_).


start(state(3,3,l)).
finish(state(0,0,r)).

route(state(M1, C1, l), state(M2, C1, r)) :- M2 is M1 -1, state(M2, C1, r).
route(state(M1, C1, l), state(M2, C1, r)) :- M2 is M1-2, state(M2, C1, r). 
route(state(M1, C1, l), state(M2, C2, r)) :- M2 is M1-1, C2 is C1-1, state(M2, C2, r).
route(state(M1, C1, l), state(M1, C2, r)) :- C2 is C1-1, state(M1, C2, r).
route(state(M1, C1, l), state(M1, C2, r)) :- C2 is C1-2,state(M1, C2, r).

route(state(M1, C1, r), state(M2, C1, l)) :- M2 is M1+1, state(M2, C1, l).
route(state(M1, C1, r), state(M2, C1, l)) :- M2 is M1+2, state(M2, C1, l).
route(state(M1, C1, r), state(M2, C2, l)) :- M2 is M1+1, C2 is C1+1, state(M2, C2, l).
route(state(M1, C1, r), state(M1, C2, l)) :- C2 is C1+1, state(M1, C2, l).
route(state(M1, C1, r), state(M1, C2, l)) :- C2 is C1+2,  state(M1, C2, l).

travelSafeLog(A, A,_, [A]) :- finish(A).
travelSafeLog(A,C, Closed, [A| Steps]) :- route(A, B), not(member(Closed, B)), travelSafeLog(B,C, [B|Closed],Steps).

solve(R) :- start(A), finish(B), travelSafeLog(A, B,[],R).