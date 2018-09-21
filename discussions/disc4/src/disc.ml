(* Polymorphic Examples*)

let f x y = x :: [y]

let g p q = match (p, q) with
| ([], []) -> 1
| (_, _) -> 2

(* Chipotle record*)
type chipotle_order = { item : string; cost : float }

(* Given a list of Chipotle orders, find the most expensive cost. Return 0.0 for empty list. *)
let find_expensive (orders : chipotle_order list) : float =
  failwith "unimplemented"

(* Map and fold are defined here for you. You may use them. *)
let rec map f l = 
  match l with
  | [] -> []
  | h :: t -> (f h) :: (map f t)

let rec foldl f acc l = 
  match l with
  | [] -> acc
  | h :: t -> foldl f (f acc h) t

let rec foldr f l acc =
	match l with
	| [] -> acc
	| h::t -> f h (foldr f t acc)

(* Name record *)
type name = { first : string ; middle : string option; last : string }

(* Returns full name string representation of the name_records in l. *)
let full_names (l : name list) : string list =
  failwith "unimplemented"

(* Vector record *)
type vector = { x : int; y : int }

(* Returns the sum of the vectors in l. *)
let sum_vectors (l : vector list) : vector =
  failwith "unimplemented"

(* Returns the sum of the ints in the lists in l. *)
let sum_list_list (l : int list list) : int =
  failwith "unimplemented"

(* Write your own map function using the provided fold function *)
let my_map (f : 'a -> 'b) (l : 'a list) : 'b list =
  failwith "unimplemented"

(* OPTIONAL: Similar to foldr except it returns all intermediate
   accumulators instead of just the last one (including the first one).
   This one is tested locally, but not on the submit server. Try it! *)
let my_scanr (f : 'a -> 'b -> 'b) (l : 'a list) (acc : 'b) : 'b list =
  failwith "unimplemented"
