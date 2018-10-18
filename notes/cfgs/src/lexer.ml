module L = List
module S = String
module R = Str
        
(* Type *)
type token =
| Tok_Var of string
| Tok_Int of int
| Tok_Eq
| Tok_LCurly
| Tok_RCurly
| Tok_Semi
| Tok_EOF

(* Regular expressions and the tokens they generate. *)
let re = [
  (R.regexp "[a-z]+" , fun x -> [Tok_Var x]) ;
  (R.regexp "[0-9]+" , fun x -> [Tok_Int (int_of_string x)]) ;
  (R.regexp "=" , fun _ -> [Tok_Eq]) ;
  (R.regexp "{" , fun _ -> [Tok_LCurly]) ;
  (R.regexp "}" , fun _ -> [Tok_RCurly]) ;
  (R.regexp ";" , fun _ -> [Tok_Semi]) ;
  (R.regexp " " , fun _ -> [])
]

(* Given source code returns a token list. *)
let rec lexer (s : string) : token list =
  lexer' s 0

(* Helper for lexer takes in a position offset. *)
and lexer' (s : string) (pos : int) : token list =
  if pos >= S.length s then [Tok_EOF]
  else
    let (_, f) = L.find (fun (re, _) -> R.string_match re s pos) re in
    let s' = R.matched_string s in
    (f s') @ (lexer' s (pos + (S.length s')))

(* Returns a string representation of a token list. *)
let rec string_of_tokens (ts : token list) : string =
  S.concat "" (L.map string_of_token ts)

(* Returns string representationof a single token. *)
and string_of_token (t : token) : string =
  match t with
  | Tok_Var x -> x
  | Tok_Int n -> string_of_int n
  | Tok_Eq -> "="
  | Tok_LCurly -> "{"
  | Tok_RCurly -> "}"
  | Tok_Semi -> ";"
  | Tok_EOF -> ""
