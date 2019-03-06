%%% standard graph search machinery
not(A) :- A, !, fail.
not(_).
member([H|_], H).
member([_|T], H) :- member(T, H).

travelSafeLog(A, A,_, [A]) :- finish(A).
travelSafeLog(A,C, Closed, [A| Steps]) :- route(A, B), not(member(Closed, B)), travelSafeLog(B,C, [B|Closed],Steps).

solve(R) :- start(A), finish(B), travelSafeLog(A, B,[],R).

%%% state ((list of (person, speed)) left in car, list of people,speed in house, umbrella = l or r, time remaining)

start(state([(a,1), (b,2), (c,5), (d,10)],[],l,17)).
finish(state([],[(a,1), (b,2), (c,5), (d,10)],r,0)).


take([H|T], H, T).
take([H|T], E, [H|R]) :- take(T, E, R).

max(X, Y, X):- X >= Y,!.
max(X, Y, Y).

%take one person and move across
route(state(L,R,l, T), state(L2, [(X,Tx)|R],r, T2)) :- take(L, (X,Tx), L2), T2 is T-Tx, T2>=0.

%take two people and move across
route(state(L, R, l, T), state(L3,[(X, Tx), (Y, Ty)|R], r, T2)) :- take(L, (X,Tx), L2), take(L2, (Y,Ty), L3), max(Tx, Ty, Txy),T2 is T-Txy, T2>=0.

%take one person and move back
route(state(L,R,r, T), state([(X,Tx)|L],R2,l, T2)) :- take(R, (X,Tx), R2), T2 is T-Tx, T2>=0.

%take two people and move back
route(state(L, R, r, T), state([(X, Tx), (Y, Ty) |L], R3, r, T2)) :- take(R, (X,Tx), R2),take(R2, (Y,Ty), R3), max(Tx, Ty, Txy), T2 is T-Txy, T2>=0.
