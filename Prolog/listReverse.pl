reverseList([], []).
reverseList([H|A],R) :- reverseList(A, R1), append(R1, [H], R).

reverseListAcc([], Acc, Acc).
reverseListAcc([H|A], Acc, R) :- reverseListAcc(A, [H|Acc], R).


reverseListDiff([], A-A).
reverseListDiff([H|A], R1-X) :- reverseListDiff(A, R1-[H|X]). 
% both diff and acc build up list backwards