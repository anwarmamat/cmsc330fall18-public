# Do You Remember?

<!--- TIME: 20 minutes -->

## A mutable dictionary

We're going to build a mutable dictionary (i.e. a key-value store) data
structure. The backing store will be a mutable associative array.

```ocaml
type ('k, 'v) dict = ('k * 'v) list ref
```

Notice that we've parameterized the type by the types of the keys and values.
The structure itself is a mutable associative array. We can then write the
constructor.

```ocaml
(* Returns a new empty dictionary *)
let empty () : ('k, 'v) dict = ref []
```

And then we have the two central operations for the dictionary.

<!--- CUE: Give students time to implement these two. -->

```ocaml
(* Creates a key-value pair association in the dictionary *)
let set (d : ('k, 'v) dict) (k : 'k) (v : 'v) : 'v =
  d := (k, v) :: (!d) ; v

(* Returns the value associated with a key (as an option) *)
let get (d : ('k, 'v) dict) (k : 'k) : 'v option =
  List.fold_right (fun (x, y) a ->
    if x = k then Some y else a) !d None
```

This is identical to an immutable associative array implementation
except `set` mutates the dictionary reference instead of returning
a new dictionary. Also, notice that we use `fold_right` so that
newer bindings will shadow older bindings.

<!--- TIME: 30 minutes -->

## Memoizing Fibonacci

Let's use our mutable dictionary to write a memoizing Fibonacci
function. Here's a normal (inefficient) version of Fibonacci.

```ocaml
(* Computes fibonacci regularly as a recursive function *)
let rec fib_reg (n : int) : int =
  if n = 1 || n = 2 then 1 else fib_reg (n - 2) + fib_reg (n - 1)
```

However, we know this version is slow. The amount of recursive
calls doubles each time. We get an exponential blow-up that
is unacceptable. Memoization can help with this.

<!--- CUE: Explain the concept of memoization if students
      don't remember. -->

We can use our mutable dictionary to memoize. This mutable
dictionary will live inside of `fib_mem`'s closure so that the
function may access and modify it. Recall how to construct
a closure.

```ocaml
let query =
  let db = ref [("red", 3) ; ("orange", 6); ("yellow", 5)] in
  (fun k -> get db k)
```

This is often called the **let over lambda** idiom. If the
function inside needs access to itself, you can change it to
be named and recursive.

```ocaml
let query =
  let db = ref [("red", 3) ; ("orange", 6); ("yellow", 5)] in
  let rec query' k =
    match get db k with
    | None -> query' "red"
    | x -> x
  in query'
```

With that in mind, you should be able to write `fib_mem`.

<!--- CUE: Give students time to make it faster. -->

```ocaml
(* Computes fibonacci with memoization *)
let fib_mem =
  let d = empty () in
  let rec fib_mem' (n : int) : int =
    match get d n with
    | Some y -> y
    | None ->
        let y = (if n = 1 || n = 2 then 1 else fib_mem' (n - 2) + fib_mem' (n - 1))
        in set d n y
  in fib_mem'
```

Here, our `fib_mem` function is a closure with `d` bound to a mutable
dictionary. Before computing `fib_mem n`, we first look to see if it's
present in our dictionary. If so, then we return the stored value.
Otherwise, we compute it normally.

<!--- TIME: 40 minutes -->

## A generalized memoizer

This works, but it's ugly! All this memoization stuff obscures the
clarity and elegance of the original `fib_reg` function. Wouldn't it be
nice if we could simply write a function called `memoizer` that will
convert a function written in a naturally recursive style and memoize
it. Turns out we can do just that.

<!--- CUE: Give students time to write this function given only
      the signature. -->

```ocaml
(* Returns a memoized version of the given unary function *)
let memoizer (f : ('a -> 'b)) : ('a -> 'b) =
  let d = empty () in
  fun x ->
    match get d x with
    | Some y -> y
    | None -> let y = f x in set d x y

let fib_fast = memoizer fib_reg
```

This is a good attempt, however it doesn't really work. Try it with
`fib_fast 35`. Slow right?

<!--- CUE: Have students try to figure out why that would be. -->

This is because the recursive calls to `fib_fast` are not memoized. Therefore,
if we call `fib_fast 35` again it will be fast. But on the first go around,
it's just as slow as before. Not so fast after all. So, how do we fix this?

<!--- CUE: Have students try to fix it on their own. -->

We can make the following modification. Instead using `fib_reg` we
can define `mk_fib` that requires an existing `fib` function.

```ocaml
(* Computes fibonacci (given a recursive fibonacci reference) *)
let mk_fib (fib : int -> int) : (int -> int) =
  fun n -> if n = 1 || n = 2 then 1 else fib (n - 2) + fib (n - 1)

(* Computes fibonacci recursively without memoization *)
let rec fib_slow (n : int) : int = (mk_fib fib_slow) n
```

<!--- CUE: Have students try to fix it on their own again. -->

Using this, we can redefine our `memoizer` function to work on the
`mk_fib` function. We can do this by providing the memoizer itself
to `mk_fib`.

```ocaml
(* Returns a memoized version of the given unary function *)
let memoizer (mk : ('a -> 'b) -> ('a -> 'b)) : ('a -> 'b) =
  let d = empty () in
  let rec memoizer' x =
    match get d x with
    | Some y -> y
    | None -> let y = (mk memoizer') x in set d x y
  in memoizer'

(* Computes fibonacci recursively with memoization *)
let fib_fast = memoizer mk_fib
```

`fib_fast` has reasonable performance, `fib_slow` doesn't. This
is really neat though. Memoization has been abstracted out to a
very generic utility, `memoizer`. You can memoize any unary
function!

Additionally, we have an extremely elegant and natural implementation
of Fibonacci without sacrificing performance.
