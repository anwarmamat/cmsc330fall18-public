type token =
| Tok_Var of string
| Tok_Int of int
| Tok_Eq
| Tok_LCurly
| Tok_RCurly
| Tok_Semi
| Tok_EOF

val lexer : string -> token list
val string_of_tokens : token list -> string
