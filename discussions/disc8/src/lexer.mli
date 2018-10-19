type token =
| Tok_Int of int
| Tok_Plus
| Tok_LParen
| Tok_RParen
| Tok_EOF

val lexer : string -> token list
