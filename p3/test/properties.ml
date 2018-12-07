open P3

module QCheckRegexp =
struct
  include QCheck

  (** Generator for characters [a-z] *)
  let lowercase =
    let open Gen in
    97 -- 122 >|= fun code -> Char.chr code

  (** Print AST for regular expression *)
  let rec regexp_ast = function
    | Regexp.Empty_String -> "EMPTY"
    | Regexp.Char c -> Printf.sprintf "CHAR %c" c
    | Regexp.Union (r1, r2) -> Printf.sprintf "(%s \\/ %s)" (regexp_ast r1) (regexp_ast r2)
    | Regexp.Concat (r1, r2) -> Printf.sprintf "(%s /\\ %s)" (regexp_ast r1) (regexp_ast r2)
    | Regexp.Star r -> Printf.sprintf "(STAR %s)" (regexp_ast r)

  (** Print AST and pretty for regular expression *)
  let regexp_both r =
    Printf.sprintf "%s\n%s" (regexp_ast r) (Regexp.regexp_to_string r)

  (** Standard size, counts constructors *)
  let rec regexp_size = function
    | Regexp.Empty_String -> 1
    | Regexp.Char _ -> 1
    | Regexp.Union(r1, r2) -> (regexp_size r1) + (regexp_size r2) + 1
    | Regexp.Concat(r1, r2) -> (regexp_size r1) + (regexp_size r2) + 1
    | Regexp.Star r -> (regexp_size r) + 1

  (** Standard shrinker, applies shrinkers recursively *)
  let rec regexp_shrink init =
    let open Iter in
    match init with
    | Regexp.Empty_String ->
      empty
    | Regexp.Char c ->
      empty

    | Regexp.Union(Regexp.Empty_String, Regexp.Empty_String) ->
      return Regexp.Empty_String
    | Regexp.Union(Regexp.Empty_String, Regexp.Char c) ->
      append_l [ return Regexp.Empty_String ;
                 return (Regexp.Char c) ]
    | Regexp.Union(Regexp.Char c, Regexp.Empty_String) ->
      append_l [ return (Regexp.Char c) ;
                 return Regexp.Empty_String ]
    | Regexp.Union(Regexp.Char c1, Regexp.Char c2) ->
      append_l [ return (Regexp.Char c1) ;
                 return (Regexp.Char c2) ]

    | Regexp.Concat(Regexp.Empty_String, Regexp.Empty_String) ->
      return Regexp.Empty_String
    | Regexp.Concat(Regexp.Empty_String, Regexp.Char c) ->
      append_l [ return Regexp.Empty_String ;
                 return (Regexp.Char c) ]
    | Regexp.Concat(Regexp.Char c, Regexp.Empty_String) ->
      append_l [ return (Regexp.Char c) ;
                 return Regexp.Empty_String ]
    | Regexp.Concat(Regexp.Char c1, Regexp.Char c2) ->
      append_l [ return (Regexp.Char c1) ;
                 return (Regexp.Char c2) ]

    | Regexp.Star(Regexp.Empty_String) ->
      return Regexp.Empty_String
    | Regexp.Star(Regexp.Char c) ->
      return (Regexp.Char c)

    | Regexp.Union(r1, r2) ->
      (regexp_shrink r1) >>= fun lhs ->
      (regexp_shrink r2) >>= fun rhs ->
      append_l [ return (Regexp.Union(lhs, r2))  ;
                 return (Regexp.Union(r1, rhs))  ;
                 return (Regexp.Union(lhs, rhs)) ]

    | Regexp.Concat(r1, r2) ->
      (regexp_shrink r1) >>= fun lhs ->
      (regexp_shrink r2) >>= fun rhs ->
      append_l [ return (Regexp.Concat(lhs, r2)) ;
                 return (Regexp.Concat(r1, rhs)) ;
                 return (Regexp.Concat(lhs, rhs)) ]

    | Regexp.Star r ->
      (regexp_shrink r) >>= fun sub ->
      return (Regexp.Star sub)

  (* INS: This is probably overkill, but technically necessary for completeness I think *)
  let size_gen size =
    let open Gen in
    if size mod 2 = 1 then (* size = 2k + 1, so make each subtree size k *)
      return (size / 2, size / 2)
    else (* size = 2k, so make one subtree size k and one size k - 1 *)
      oneof [ return ((size / 2) - 1, size / 2) ;
              return (size / 2, (size / 2) - 1) ]

  (** Generate a regular expression with `size` constructors *)
  let rec regexp_gen_size size =
    let open Gen in
    match size with
    | 1 ->
      oneof [ return Regexp.Empty_String ;
              lowercase >|= fun c -> Regexp.Char c ]
    | 2 ->
      oneof [ return (Regexp.Star Regexp.Empty_String) ;
              lowercase >|= fun c -> Regexp.Star (Regexp.Char c) ]
    | _ ->
      oneof [ (size_gen size     >>= fun (l, r) ->
               regexp_gen_size l >>= fun lhs    ->
               regexp_gen_size r >>= fun rhs    ->
               return (Regexp.Union (lhs, rhs)))  ;
              (size_gen size     >>= fun (l, r) ->
               regexp_gen_size l >>= fun lhs    ->
               regexp_gen_size r >>= fun rhs    ->
               return (Regexp.Concat (lhs, rhs))) ;
              (regexp_gen_size (size - 1) >>= fun sub ->
               return (Regexp.Star sub)) ]

  (** Generate a small natural number, and generate a regular expression of that size *)
  let rec regexp_gen =
    let open Gen in
    1 -- 32 >>= fun n ->
    regexp_gen_size n

  let regexp_t : Regexp.regexp_t arbitrary =
    make
      ~print:regexp_both
      ~small:regexp_size
      ~shrink:regexp_shrink
      regexp_gen
end

let rec regexp_normal r = r

let rec regexp_equiv r1 r2 =
  let r1' = regexp_normal r1 in
  let r2' = regexp_normal r2 in
  r1' = r2'

(** string_to_regexp ∘ regexp_to_string = id *)
(* TODO(ins): This should really be an equivalence, since operators are associative *)
let regexp_inverses =
  QCheckRegexp.(Test.make
                  ~name:"regexp_inverses"
                  ~max_fail:100
                  ~count:10000
                  regexp_t
                  (fun regexp ->
                     regexp_equiv regexp (Regexp.string_to_regexp (Regexp.regexp_to_string regexp))))

let suite =
  [ regexp_inverses ]

let _ =
  QCheck_base_runner.set_seed 0;
  QCheck_base_runner.run_tests_main suite
