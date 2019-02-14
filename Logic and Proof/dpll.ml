type term = Var of char | Implies of term * term | And of term * term | Or of term * term | Not of term 

let rec remImp expr = 
	match expr with
	| Implies(p,q) -> Or(Not(remImp p), (remImp q))
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


let cnf expr = pushDisj (pushNegs ( remImp expr));;

(* to make parsing easier, convert CNF into list of lists of literals, where each list of literals is a clause *)
let rec makeClauses expr = 
    let rec parseClause c = 
        (match c with
        | Or(c1, c2) -> ((parseClause c1) @ (parseClause c2))
        | Not(Not(x)) -> (parseClause x) (* get rid of double negation *)
        | _ -> [c])
    in match expr with 
    | And(e1, e2) -> ((makeClauses e1) @ (makeClauses e2))
    | _ ->[(parseClause expr)];;

let rec member x list =
    match list with 
    | [] -> false
    |  y::ys -> x=y || (member x ys);;

let rec tautClause c = 
     match c with 
    |   Var(x) :: ys -> (member (Not(Var(x))) ys) || (tautClause ys)
    |  Not(Var(x)) :: ys -> (member (Var(x)) ys) || (tautClause ys)
    |  _  -> false ;;

let rec deleteMember pred list = 
    match list with 
    | [] -> []
    | c :: cs -> if (pred c) then (deleteMember pred cs) else (c::(deleteMember pred cs));;

let rec deleteMemberList pred listOfLists = 
    match listOfLists with 
    | [] -> []
    | c :: cs -> (deleteMember pred c) :: (deleteMemberList pred cs);;


let rec unitPropagation clauses = 
    let rec iterHelper(list, rs) = 
        (match list with
        | [] -> rs
        | [Var(x)]::cs -> (unitPropagation (
            deleteMemberList (member (Not(Var(x))) ) 
            (deleteMember (member (Var(x))) (cs@rs)  ) 
            )
            )
        | [(Not(Var(x)))]::cs -> (unitPropagation (deleteMemberList (member (Var(x))) (deleteMember (member (Not(Var(x)))) (cs@rs)  ) ))
        | c::cs -> iterHelper(cs, c::rs)
        )
    in iterHelper(clause, []);;