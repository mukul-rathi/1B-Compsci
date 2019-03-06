%%%%%%%%% 28S.1 Selection Sort

take([H|T], H, T).
take([H|T], X, [H|R]) :- take(T, X, R).

perm([],[]).
perm(L, [H|R]) :- take(L,H, L2), perm(L2, R).


sorted([X]).
sorted([H1, H2 |T]):- H1 =< H2, sorted([H2|T]).


minElem(L, H, R) :- perm(L, [H|R]), sorted([H|R]).

selectionSort([],[]) :- !.
selectionSort(L, [H|T]) :- minElem(L, H, R), !,  selectionSort(R, T).

%%%%%%%%%%% 28S.2 

partition([], [], [], _).
partition([H|A],[H|L], R, X) :- H=<X, !, partition(A, L, R, X). 
partition([H|A],L, [H|R], X) :- partition(A, L, R, X).

 
quickSort([], []).
quickSort([H|A], B) :- partition(A, L, R, H), quickSort(L, L2), quickSort(R, R2), append(L2, [H|R2], B). 
 
 
 %%%%%%% 28S.3


partition2([], [], [], [], _).
partition2([H|A],[H|L],M,  R, X) :- H<X, !, partition2(A, L,M, R, X). 
partition2([H|A],L,M,[H|R], X) :- H>X, !, partition2(A, L,M, R, X).
partition2([H|A],L,[H|M],R, X) :-  partition2(A, L,M, R, X).

 
quickSort2([], []).
quickSort2([H|A], B) :- partition2(A, L,M, R, H), quickSort2(L, L2), quickSort2(R, R2), append(L2,M, B1), append(B1, [H|R], B). 
 
 %%%%% 28S.4 - desirable if list has a lot of duplicate elements.


 %%%%%%%%%%%28S.5

quickSortDif([], A-A).
quickSortDif([H|A], L1-R2) :- partition(A, L, R, H), quickSortDif(L, L1-[H|R1]), quickSortDif(R, R1-R2).

%%%%%%%%%28S.6

merge(L, [], L) :- !.
merge([], R, R) :- !.
merge([H1|L], [H2|R], [H1|S]) :- H1 =< H2,!, merge(L, [H2|R], S).
merge([H1|L], [H2|R], [H2|S]) :- merge([H1|L], R, S).

splitLists([], [], []).
splitLists([X], [X], []).
splitLists([H1,H2|X],[H1|L], [H2|R]) :- splitLists(X,L,R).

mergeSort([],[]):-!.
mergeSort([X], [X]):-!.
mergeSort(X, Y):- splitLists(X, L, R),!, mergeSort(L, L1),mergeSort(R, R1), merge(L1, R1, Y).


