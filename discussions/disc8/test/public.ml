open OUnit2
open Disc.Lexer
open Disc.Parser

let test_one ctxt =
  assert_equal (Int 1) (parser [Tok_Int 1; Tok_EOF])

let test_one_plus_two ctxt =
  assert_equal (Plus (Int 1, Int 2)) (parser [Tok_Int 1; Tok_Plus; Tok_Int 2; Tok_EOF])

let test_right_associative ctxt =
  assert_equal (Plus (Int 1, Plus (Int 2, Int 3))) (parser [Tok_Int 1; Tok_Plus; Tok_Int 2; Tok_Plus; Tok_Int 3; Tok_EOF])

let test_parentheses ctxt =
  assert_equal (Plus (Plus (Int 1, Int 2), Int 3)) (parser [Tok_LParen; Tok_Int 1; Tok_Plus; Tok_Int 2; Tok_RParen; Tok_Plus; Tok_Int 3; Tok_EOF])

let suite =
  "public" >::: [
    "one" >:: test_one;
    "one_plus_two" >:: test_one_plus_two;
    "right_associative" >::  test_right_associative;
    "parentheses" >:: test_parentheses
  ]

let _ = run_test_tt_main suite
