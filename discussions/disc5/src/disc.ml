(********************)
(* String Functions *)
(********************)

(* Joins together the strings in xs by separator sep
   e.g. join ["cat"; "dog"; "fish"] "," = "cat,dog,fish". *)
let join (xs : string list) (sep : string) : string =
  ""

(********************)
(* Option Functions *)
(********************)

(* Converts an option to a list. Some is a singleton containing
   the value, while None is an empty list. *)
let list_of_option (o : 'a option) : 'a list =
  []

(* Returns the first option that contains a value, None otherwise
   e.g. getFirst (Some 1) (Some 2) = Some 1
        getFirst None (Some 2) = Some 2. *)
let get_first (o : 'a option) (p : 'a option) : 'a option =
  None

(* If the pair's key matches k then return the value as an option.
   Otherwise return None. *)
let match_key (k : 'k) (p : ('k * 'v)) : 'v option =
  None

(************************)
(* Dictionary Functions *)
(************************)

(* Here is the type for dictionaries *)
type ('k, 'v) dict = ('k * 'v) list

(* Creates a key-value pair association in the dictionary. *)
let set (d : ('k, 'v) dict) (k : 'k) (v : 'v) : ('k, 'v) dict =
  []

(* Returns the value associated with a key (as an option) *)
let get (d : ('k, 'v) dict) (k : 'k) : 'v option =
  None

(* Given a list of keys, returns a list of options of the associated
   values (and None if the key wasn't found in the dictionary d). *)
let get_some_values (d : ('k, 'v) dict) (ks : 'k list) : 'v option list =
  []

(* Given a list of keys, returns a list of the values associated
   with the keys (not as options).
   e.g. get_values [(1, 2); (3, 4)] [1; 0; 3] = [2; 4] *)
let get_values (d : ('k, 'v) dict) (ks : 'k list) : 'v list =
  []
