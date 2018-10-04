open P3.Nfa
open P3.Regexp
open TestUtils
open OUnit2

let m1 = {
  qs = [0; 1; 2; 3];
  sigma = ['a'; 'b'];
  delta = [(0, Some 'a', 1); (0, Some 'a', 2); (2, Some 'b', 3)];
  q0 = 0;
  fs = [1; 3]
}

let test_nfa_new_states ctxt =
  assert_set_set_eq [[]; []] (new_states m1 []);
  assert_set_set_eq [[1; 2]; []] (new_states m1 [0]);
  assert_set_set_eq [[1; 2]; [3]] (new_states m1 [0; 2]);
  assert_set_set_eq [[1; 2]; [3]] (new_states m1 [0; 1; 2; 3])

let test_nfa_new_trans ctxt =
  assert_trans_eq [([0], Some 'a', [1; 2]); ([0], Some 'b', [])] (new_trans m1 [0]);
  assert_trans_eq [([0; 2], Some 'a', [1; 2]); ([0; 2], Some 'b', [3])] (new_trans m1 [0; 2])

let test_nfa_new_finals ctxt =
  assert_set_set_eq [] (new_finals m1 [0; 2]);
  assert_set_set_eq [[1]] (new_finals m1 [1]);
  assert_set_set_eq [[1; 3]] (new_finals m1 [1; 3])


let suite =
  "student" >::: [
    "nfa_new_states" >:: test_nfa_new_states;
    "nfa_new_trans" >:: test_nfa_new_trans;
    "nfa_new_finals" >:: test_nfa_new_finals
  ]

let _ = run_test_tt_main suite
