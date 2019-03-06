tName(acr31,'Andrew Rice').
tName(arb33,'Alastair Beresford').
tName(msr45, 'Mukul Rathi').
tCollege(zgg58, 'Queens').
tCollege(acr31, 'Churchill').
tCollege(arb33, 'Robinson').

tGrade(acr31,'IA',2.1).
tGrade(acr31,'IB',1).
tGrade(acr31,'II',1).
tGrade(arb33,'IA',2.1).
tGrade(arb33,'IB',1).
tGrade(arb33,'II',1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 22.S4


not(A) :- A, !, fail.
not(_).

qFOJoinNameCollege(N,C) :- tName(I, N), tCollege(I, C).
qFOJoinNameCollege(N,'') :- tName(I,N), not(tCollege(I, _)).
qFOJoinNameCollege('',C) :- tCollege(I, C), not(tName(I, _)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%22.S5
member([H|_], H).
member([_|T], H) :- member(T, H).

take([H|T], H, T).
take([H|T], X, [H|R]) :- take(T, X, R).

perm([],[]).
perm(L, [H|R]) :- take(L,H, L2), perm(L2, R).



%generate a list of all year, grades associated with crsid
getGrades(C, A, Found) :- tGrade(C,Y,G), not(member(Found,(Y,G))),!, getGrades(C, A, [(Y,G)|Found]).
getGrades(C, A, A).


%order grades min to max
lessThanEqual(2.2,2.2).
lessThanEqual(2.2,2.1).
lessThanEqual(2.1,2.1).
lessThanEqual(2.1,1).
lessThanEqual(1,1).

% true if list of (year,grades) is weakly ascending in order of grades
lessThanEqual([X]).
lessThanEqual([(_,G1), (_,G2)|T]) :- lessThanEqual(G1, G2),lessThanEqual([(_,G2)|T]).

% choose head of sorted list of grades (sorted list comes from perm and lessThanEqual)
qMinGrade(C, G) :- getGrades(C, L, []), perm(L, [(Y,G)|L2]), lessThanEqual([(Y,G)|L2]), !. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%22.S6

%generate a list of all crsids and years associated with 1st
getCrsidYears(G,A, Found) :- tGrade(C,Y,G), not(member(Found,(C,Y))),!, getCrsidYears(G, A, [(C, Y)|Found]).
getCrsidYears(G, A, A).

%length of  list
len([], 0).
len([H|T], M) :- len(T, N), M is N+1.

qNumFirsts(N) :- getCrsidYears(1, L, []), len(L, N).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%22.S7

%come up with list of unique crsids with a first
listCrsidsWithFirsts(A, Found) :- tGrade(C,_,1), not(member(Found,C)),!, listCrsidsWithFirsts(A, [C|Found]).
listCrsidsWithFirsts(A,A).

%count number of firsts in list of (year, grade)
numFirstsInList([], 0).
numFirstsInList([(_,1)|T], M) :- !, numFirstsInList(T, N), M is N+1.
numFirstsInList([_|T], M) :- numFirstsInList(T, M).

%get list of grades associated with each crsid in the list of crsids with firsts and then count number of firsts
qNumFirstsByCrsid(C, N) :- listCrsidsWithFirsts(Cs, []), take(Cs, C, _) ,getGrades(C,L, []),numFirstsInList(L, N). 

