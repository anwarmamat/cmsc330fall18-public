open Lexer

(* Types *)

type var = string
type expr =
| Assign of var * int
| Seq of expr * expr
| Skip

(* Parsing helpers *)

let tok_list = ref []

(* Returns next token in the list. *)
let lookahead () : token =
  match !tok_list with
  | [] -> raise (Failure "no tokens")
  | h :: t -> h

(* Matches the top token in the list. *)
let match_tok (a : token) : unit =
  match !tok_list with
  | h :: t when a = h -> tok_list := t
  | _ -> raise (Failure "bad match")

(* Parses a token list. *)
let rec parser (toks : token list) : expr =
  tok_list := toks;
  let exp = parse_E () in
  if !tok_list <> [Tok_EOF] then
    raise (Failure "did not reach EOF")
  else
    exp

(* Parses the E rule. *)
and parse_E () : expr =
  match lookahead () with
  | Tok_Var id ->
      (match_tok (Tok_Var id);
       match_tok Tok_Eq;
       match lookahead () with
       | Tok_Int n -> match_tok (Tok_Int n);
                      Assign (id, n)
       | _ -> raise (Failure "parse_E failure"))
  | Tok_LCurly ->
      (match_tok Tok_LCurly;
       let e = parse_L () in
       match_tok Tok_RCurly;
       e)
  | _ -> raise (Failure "parse_E failure")
            
(* Parses the L rule. *)
and parse_L () : expr =
  match lookahead () with
  | Tok_Var _ | Tok_LCurly ->
      let m = parse_E () in
      match_tok Tok_Semi;
      let n = parse_L () in
      Seq (m, n)
  | _ -> Skip

(* Returns string representation of the AST. *)
let rec string_of_expr (m : expr) : string =
  match m with
  | Assign (id, n) -> id ^ " = " ^ (string_of_int n)
  | Seq (m, n) -> "{" ^ (string_of_expr m) ^ ";" ^ (string_of_expr n) ^ "}"
  | Skip -> ""
