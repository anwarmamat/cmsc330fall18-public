open OUnit2
open Basics
open TestUtils

let test_pyth ctxt =
  assert_equal true (pyth 3 4 5) ~msg:"pyth (1)" ~printer:string_of_bool;
  assert_equal true (pyth 6 8 10) ~msg:"pyth (2)" ~printer:string_of_bool;
  assert_equal false (pyth 1 2 3) ~msg:"pyth (3)" ~printer:string_of_bool;
  assert_equal true (pyth 5 12 13) ~msg:"pyth (4)" ~printer:string_of_bool

let test_gcd ctxt =
  assert_equal 4 (gcd 8 12) ~msg:"gcd (1)" ~printer:string_of_int;
  assert_equal 6 (gcd 54 24) ~msg:"gcd (2)" ~printer:string_of_int;
  assert_equal 10 (gcd 110 200) ~msg:"gcd (3)" ~printer:string_of_int;
  assert_equal 2 (gcd 4 6) ~msg:"gcd (4)" ~printer:string_of_int

let test_reduced_form ctxt =
  assert_equal (4, 1) (reduced_form 12 3) ~msg:"reduced_form (1)" ~printer:string_of_int_pair;
  assert_equal (5, 6) (reduced_form 5 6) ~msg:"reduced_form (2)" ~printer:string_of_int_pair;
  assert_equal (3, 1) (reduced_form 27 9) ~msg:"reduced_form (3)" ~printer:string_of_int_pair;
  assert_equal (2, 3) (reduced_form 12 18) ~msg:"reduced_form (4)" ~printer:string_of_int_pair

let test_cubes ctxt =
  assert_equal 100 (cubes 4) ~msg:"cubes (1)" ~printer:string_of_int;
  assert_equal 9 (cubes 2) ~msg:"cubes (2)" ~printer:string_of_int;
  assert_equal 14400 (cubes 15) ~msg:"cubes (3)" ~printer:string_of_int;
  assert_equal 1296 (cubes 8) ~msg:"cubes (4)" ~printer:string_of_int

let test_ack ctxt =
  assert_equal 61 (ack 3 3) ~msg:"ack (1)" ~printer:string_of_int;
  assert_equal 4 (ack 1 2) ~msg:"ack (2)" ~printer:string_of_int;
  assert_equal 7 (ack 2 2) ~msg:"ack (3)" ~printer:string_of_int

let test_max_first_three ctxt =
  assert_equal 7 (max_first_three [7; 4; 7]) ~msg:"max_first_three (1)" ~printer:string_of_int;
  assert_equal 2 (max_first_three [2; 2; 2]) ~msg:"max_first_three (2)" ~printer:string_of_int;
  assert_equal 10 (max_first_three [10; 0; 1]) ~msg:"max_first_three (3)" ~printer:string_of_int;
  assert_equal 3 (max_first_three [3; 2; 0]) ~msg:"max_first_three (4)" ~printer:string_of_int

let test_count_occ ctxt =
  assert_equal 2 (count_occ [2; 2; 3] 2) ~msg:"count_occ (1)" ~printer:string_of_int;
  assert_equal 1 (count_occ [1; 2; 1] 2) ~msg:"count_occ (2)" ~printer:string_of_int;
  assert_equal 3 (count_occ [1; 1; 1] 1) ~msg:"count_occ (3)" ~printer:string_of_int
  
let test_uniq ctxt = 
  assert_equal [4; 3] (uniq [4; 4; 3]) ~msg:"uniq (1)" ~printer:string_of_int_list;
  assert_equal [2; 1] (uniq [2; 1; 1; 1]) ~msg:"uniq (2)" ~printer:string_of_int_list;
  assert_equal [10; 5; 7; 1] (uniq [10; 5; 7; 7; 1]) ~msg:"uniq (3)" ~printer:string_of_int_list
  
let test_assoc_list ctxt = 
  assert_equal [(2,2);(3,1)] (assoc_list [2; 2; 3]) ~msg:"assoc_list (1)" ~printer:string_of_int_pair_list;
  assert_equal [(1,1);(2,2);(3,3)] (assoc_list [1; 2; 2; 3; 3; 3]) ~msg:"assoc_list (2)" ~printer:string_of_int_pair_list;
  assert_equal [(1,1);(5,3);(2,1)] (assoc_list [1; 5; 5; 5; 2]) ~msg:"assoc_list (3)" ~printer:string_of_int_pair_list

let test_zip ctxt =
  assert_equal [(1, 2); (3, 4)] (zip [1;3] [2;4]) ~msg:"zip (1)" ~printer:string_of_int_pair_list;
  assert_equal [(1, 2)] (zip [1;3] [2]) ~msg:"zip (2)" ~printer:string_of_int_pair_list;
  assert_equal [] (zip [] []) ~msg:"zip (3)" ~printer:string_of_int_pair_list

let test_elem ctxt =
  assert_equal false (elem 3 (create_set [])) ~msg:"elem (1)" ~printer:string_of_bool;
  assert_equal true (elem 5 (create_set [2;3;5;7;9])) ~msg:"elem (2)" ~printer:string_of_bool;
  assert_equal false (elem 4 (create_set [2;3;5;7;9])) ~msg:"elem (3)" ~printer:string_of_bool

let test_remove ctxt =
  assert_set_equal_msg (create_set []) (remove 5 (create_set [])) ~msg:"remove (1)";
  assert_set_equal_msg (create_set [2;3;7;9]) (remove 5 (create_set [2;3;5;7;9])) ~msg:"remove (2)";
  assert_set_equal_msg (create_set [2;3;5;7;9]) (remove 4 (create_set [2;3;5;7;9])) ~msg:"remove (3)"

let test_union ctxt =
  assert_set_equal_msg (create_set [2;3;5]) (union (create_set []) (create_set [2;3;5])) ~msg:"union (1)";
  assert_set_equal_msg (create_set [2;3;5;7;9]) (union (create_set [2;5]) (create_set [3;7;9])) ~msg:"union (2)";
  assert_set_equal_msg (create_set [2;3;7;9]) (union (create_set [2;3;9]) (create_set [2;7;9])) ~msg:"union (3)"

let test_intersection ctxt =
  assert_set_equal_msg (create_set []) (intersection (create_set [2;3;5]) (create_set [])) ~msg:"intersection (1)";
  assert_set_equal_msg (create_set []) (intersection (create_set [3;7;9]) (create_set [2;5])) ~msg:"intersection (2)";
  assert_set_equal_msg (create_set [5]) (intersection (create_set [2;5;9]) (create_set [3;5;7])) ~msg:"intersection (3)"

let test_product ctxt =
  assert_set_equal_msg (product (create_set []) (create_set [2;3;5])) (create_set []) ~msg:"product (1)";
  assert_set_equal_msg (product (create_set [5;7]) (create_set [2;5])) (create_set [(5,2);(5,5);(7,2);(7,5)]) ~msg:"product (2)";
  assert_set_equal_msg (product (create_set [2]) (create_set [3;9])) (create_set [(2,3);(2,9)]) ~msg:"product (3)"

let test_subset ctxt =
  assert_equal true (subset (create_set [2]) (create_set [2;3;5;7;9])) ~msg:"subset (1)" ~printer:string_of_bool;
  assert_equal true (subset (create_set [3;5]) (create_set [2;3;5;7;9])) ~msg:"subset (2)" ~printer:string_of_bool;
  assert_equal false (subset (create_set [4;5]) (create_set [2;3;5;7;9])) ~msg:"subset (3)" ~printer:string_of_bool

let suite =
  "public" >::: [
    "pyth" >:: test_pyth;
    "gcd" >:: test_gcd;
    "reduced_form" >:: test_reduced_form;
    "cubes" >:: test_cubes;
    "ack" >:: test_ack;

    "max_first_three" >:: test_max_first_three;
    "count_occ" >:: test_count_occ;
    "uniq" >:: test_uniq;
    "assoc_list" >:: test_assoc_list;
    "zip" >:: test_zip;

    "elem" >:: test_elem;
    "subset" >:: test_subset;
    "remove" >:: test_remove;
    "union" >:: test_union;
    "intersection" >:: test_intersection;
    "product" >:: test_product
  ]

let _ = run_test_tt_main suite
