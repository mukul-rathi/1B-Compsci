partition([], [], [], _).
partition([H|A],[H|L], R, X) :- H=<X, !, partition(A, L, R, X). 
partition([H|A],L, [H|R], X) :- partition(A, L, R, X).

quickSort([], []).
quickSort([H|A], B) :- partition(A, L, R, H), quickSort(L, L2), quickSort(R, R2), append(L2, [H|R2], B). 

% look at appends and then only sub lists in places where append

quickSortDif([], A-A).
quickSortDif([H|A], L1-R2) :- partition(A, L, R, H), quickSortDif(L, L1-[H|R1]), quickSortDif(R, R1-R2).
 