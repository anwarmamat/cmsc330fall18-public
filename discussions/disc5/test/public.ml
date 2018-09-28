open OUnit2
open Disc

let test_join ctxt =
  assert_equal "" @@ join [] ",";
  assert_equal "cat" @@ join ["cat"] ",";
  assert_equal "cat,dog,fish" @@ join ["cat"; "dog"; "fish"] ","

let test_list_of_option ctxt =
  assert_equal [] @@ list_of_option None;
  assert_equal [1] @@ list_of_option (Some 1)
      
let test_get_first ctxt =
  assert_equal None @@ get_first None None;
  assert_equal (Some 1) @@ get_first (Some 1) None;
  assert_equal (Some 1) @@ get_first None (Some 1);
  assert_equal (Some 1) @@ get_first (Some 1) (Some 2)
  
let test_match_key ctxt =
  assert_equal None @@ match_key 1 (2, 3);
  assert_equal (Some 2) @@ match_key 1 (1, 2)
      
let test_set_and_get ctxt =
  let xs = [] in
  assert_equal None @@ get xs 1;
  
  let xs = set xs 1 2 in
  assert_equal (Some 2) @@ get xs 1;

  let xs = set xs 2 3 in
  assert_equal (Some 2) @@ get xs 1;
  assert_equal (Some 3) @@ get xs 2;

  let xs = set xs 1 4 in
  assert_equal (Some 4) @@ get xs 1;
  assert_equal (Some 3) @@ get xs 2

let test_get_some_values ctxt =
  let d = [(1, 2); (2, 3); (3, 4)] in
  assert_equal [] @@ get_some_values d [];
  assert_equal [Some 2; Some 3; Some 4] @@ get_some_values d [1; 2; 3];
  assert_equal [Some 2; None; Some 4] @@ get_some_values d [1; 0; 3]

let test_get_values ctxt =
  let d = [(1, 2); (2, 3); (3, 4)] in
  assert_equal [] @@ get_values d [];
  assert_equal [2; 3; 4] @@ get_values d [1; 2; 3];
  assert_equal [2; 4] @@ get_values d [1; 0; 3]

let suite =
  "public" >::: [
    "join" >:: test_join;
    "list_of_option" >:: test_list_of_option;
    "get_first" >:: test_get_first;
    "match_key" >:: test_match_key;
    "set_and_get" >:: test_set_and_get;
    "get_some_values" >:: test_get_some_values;
    "get_values" >:: test_get_values
  ]

let _ = run_test_tt_main suite
