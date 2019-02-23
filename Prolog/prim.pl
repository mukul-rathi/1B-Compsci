prim(0, z):- !.
prim(X, s(Z)) :- X>=1, Y is X-1, prim(Y, Z).

plus(z, B, B).
plus(s(A), B, s(C)):- plus(A, B, C).

mult(z, _, z).
mult(s(A), B, C) :- mult(A, B, C1), plus(B, C1, C).