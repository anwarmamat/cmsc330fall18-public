type var = string
type expr =
| Assign of var * int
| Seq of expr * expr
| Skip

val parser : Lexer.token list -> expr
val string_of_expr : expr -> string
