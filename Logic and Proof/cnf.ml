type term = Var of char | Implies of term * term | And of term * term | Or of term * term | Not of term 

let rec remImp expr = 
	match expr with
	| Implies(p,q) -> Or(Not(p), q)
	| And(p,q) -> And((remImp p), (remImp q))
	| Or(p,q) ->  Or((remImp p), (remImp q))
	| Not(p) -> Not((remImp p))
	| _ -> expr;;(* Var case *)

let rec pushNegs expr = (*Note at this point we have removed all implies *)
	match expr with
	| And(p,q) -> And((pushNegs p), (pushNegs q))
	| Or(p,q) -> Or((pushNegs p), (pushNegs q))
	| Not(e) ->
		(match e with
		| And(p,q) -> Or((pushNegs (Not(p)) ), (pushNegs (Not(q)) ))
		| Or(p,q) -> And((pushNegs (Not(p)) ), (pushNegs (Not(q)) ))
		| Not(e) -> (pushNegs e)
		| _ -> Not(e) (*Var  case*)
		)	
	| _ -> expr;; (*Var case *)


let rec pushDisj expr = 
	match expr with
	| And(p, q) -> And((pushDisj p), (pushDisj(q)))
	| Or( a, And(b, c)) -> And((pushDisj(Or(a, b))),  (pushDisj(Or(a, c))) )
	| Or( And(b, c), a) -> And((pushDisj(Or(a, b))),  (pushDisj(Or(a, c))) )
	(* with the Or, we may have And statements after we recursively push the disjunction out of the argument, in which case we need to 
		push the And out one more level *)
	| Or (p, q) -> (let a = pushDisj p  
					in let b = pushDisj q
						in (match a with
						| And(_,_) -> pushDisj (Or(a,b))
						| _ -> (match b with
							|  And(_,_) -> pushDisj (Or(a,b))
							| _ -> Or(a,b)
							)
						)
					)
	| _ -> expr;; (* Not and Var cases *)

(*TODO write a function to simplify expression*)

let cnf expr = pushDisj (pushNegs ( remImp expr));;

