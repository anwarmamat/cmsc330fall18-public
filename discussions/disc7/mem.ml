type ('k, 'v) dict = ('k * 'v) list ref

(* Returns a new empty dictionary *)
let empty () : ('k, 'v) dict = ref []

(* Creates a key-value pair association in the dictionary *)
let set (d : ('k, 'v) dict) (k : 'k) (v : 'v) : 'v =
  d := (k, v) :: (!d) ; v

(* Returns the value associated with a key (as an option) *)
let get (d : ('k, 'v) dict) (k : 'k) : 'v option =
  List.fold_right (fun (x, y) a ->
    if x = k then Some y else a) !d None

(* Computes fibonacci regularly as a recursive function *)
let rec fib_reg (n : int) : int =
  if n = 1 || n = 2 then 1 else fib_reg (n - 2) + fib_reg (n - 1)

(* Computes fibonacci with memoization *)
let fib_mem =
  let d = empty () in
  let rec fib (n : int) : int =
    match get d n with
    | Some y -> y
    | None -> let y = (if n = 1 || n = 2 then 1 else fib (n - 2) + fib (n - 1))
              in set d n y
   in fib

(* Returns a memoized version of the given unary function *)
let memoizer (mk : ('a -> 'b) -> ('a -> 'b)) : ('a -> 'b) =
  let d = empty () in
  let rec f x =
    match get d x with
    | Some y -> y
    | None -> let y = (mk f) x in set d x y ; y
  in f

(* Computes fibonacci (given a recursive fibonacci reference) *)
let mk_fib (fib : int -> int) : (int -> int) =
  fun n -> if n = 1 || n = 2 then 1 else fib (n - 2) + fib (n - 1)

(* Computes fibonacci recursively without memoization *)
let rec fib_slow (n : int) : int =
  (mk_fib slow_fib) n

(* Computes fibonacci recursively with memoization *)
let fib_fast = memoizer mk_fib
