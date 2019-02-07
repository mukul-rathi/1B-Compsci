d(r, g).
d(r, b).
d(r, o).

d(g, r).
d(g, b).
d(g, o).
d(b, g).
d(b, r).
d(b, o).

diff(X,Y) :- d(X,Y).
diff(X,Y) :- d(Y,X).

:- diff(C1, C2), diff(C1,C4), diff(C1,C5), diff(C1, C6), diff(C2, C3), diff(C2,C4), diff(C2,C7), diff(C3,C7), diff(C3,C8), diff(C4, C6), diff(C4,C7), diff(C5, C6), diff(C6,C7), diff(C7,C8), diff(C6,C8), print(C1), print(C2), print(C3), print(C4), print(C5), print(C6), print(C7),print(C8).
