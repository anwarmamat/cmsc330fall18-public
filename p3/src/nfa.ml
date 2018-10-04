open List
open Sets

(*********)
(* Types *)
(*********)

type ('q, 's) transition = 'q * 's option * 'q
type ('q, 's) nfa_t = {
  qs : 'q list;
  sigma : 's list;
  delta : ('q, 's) transition list;
  q0 : 'q;
  fs : 'q list;
}

(***********)
(* Utility *)
(***********)

let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

(****************)
(* Part 1: NFAs *)
(****************)

let move m qs s = failwith "unimplemented"

let e_closure m qs = failwith "unimplemented"

let accept m str = failwith "unimplemented"

(*******************************)
(* Part 2: Subset Construction *)
(*******************************)

let new_states m qs = failwith "unimplemented"

let new_trans m qs = failwith "unimplemented"

let new_finals m qs = failwith "unimplemented"

let rec nfa_to_dfa_step m dfa wrk = failwith "unimplemented"

let nfa_to_dfa m = failwith "unimplemented"
