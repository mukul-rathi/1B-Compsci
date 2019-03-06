:- use_module(library(clpfd)).

solve1([S,E,N,D],[M,O,R,E],[M,O,N,E,Y]) :-
Var = [S,E,N,D,M,O,R,Y],
Var ins 0..9, all_different(Var),
1000*S + 100*E + 10*N + D +
1000*M + 100*O + 10*R + E #=
10000*M + 1000*O + 100*N + 10*E + Y,
labeling([],Var).

%% 32S.1 25 solutions

%%%%%%%32S.2

solve2([S,E,N,D],[M,O,R,E],[M,O,N,E,Y]) :-
Var = [S,E,N,D,M,O,R,Y],
Var ins 0..9, all_different(Var),
1000*S + 100*E + 10*N + D +
1000*M + 100*O + 10*R + E #=
10000*M + 1000*O + 100*N + 10*E + Y, S#\=0, M#\=0,
labeling([],Var).

%%%%% only 1 distinct solution remains now


%%%%%32S.3

solve3([S,E,N,D],[M,O,R,E],[M,O,N,E,Y], B) :-
Var = [S,E,N,D,M,O,R,Y], B1 is B -1,
Var ins 0..B1, all_different(Var),
B*B*B*S + B*B*E + B*N + D +
B*B*B*M + B*B*O + B*R + E #=
B*B*B*B*M + B*B*B*O + B*B*N + B*E + Y, S#\=0, M#\=0,
labeling([],Var).

%%%% 28 solutions in base 16