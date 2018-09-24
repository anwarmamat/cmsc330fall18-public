open OUnit2
open P2b.Data
open P2b.Funs
open P2b.Higher

let test_high_order_1 ctxt =
  let x = [5.0;6.0;7.0] in
  let y = ["a";"a";"b";"a"] in
  let z = [1;7;7;1;5;2;7;7] in
  let a = [true;false;false;true;false;false;false] in
  let b = [] in
  let cmp x y = if x < y then (-1) else if x = y then 0 else 1 in

  assert_equal (1,1,1) @@ (count_occ x 5.0, count_occ x 6.0, count_occ x 7.0);
  assert_equal (3,1) @@ (count_occ y "a", count_occ y "b");
  assert_equal (2,4,1,1) @@ (count_occ z 1, count_occ z 7, count_occ z 5, count_occ z 2);
  assert_equal (2,5) @@ (count_occ a true, count_occ a false);
  assert_equal (0,0) @@ (count_occ b "a", count_occ b 1);

  assert_equal [5.0;6.0;7.0] @@ List.sort cmp (uniq x);
  assert_equal ["a";"b"] @@ List.sort cmp (uniq y);
  assert_equal [1;2;5;7] @@ List.sort cmp (uniq z);
  assert_equal [false;true] @@ List.sort cmp (uniq a);
  assert_equal [] @@ uniq b;

  assert_equal [(5.0,1);(6.0,1);(7.0,1)] @@ List.sort cmp (assoc_list x);
  assert_equal [("a",3);("b",1)] @@ List.sort cmp (assoc_list y);
  assert_equal [(1,2);(2,1);(5,1);(7,4)] @@ List.sort cmp (assoc_list z);
  assert_equal [(false,5);(true,2)] @@ List.sort cmp (assoc_list a);
  assert_equal [] @@ assoc_list b

let test_high_order_2 ctxt =
  let x = [5;6;7;3] in
  let y = [5;6;7] in
  let z = [7;5] in
  let a = [3;5;8;10;9] in
  let b = [3] in
  let c = [] in

  let fs1 = [((+) 2) ; (( * ) 7)] in
  let fs2 = [pred] in
  let f1 = (fun x -> [x-1; x+1]) in
  let f2 = (fun x -> [x * 2]) in

  assert_equal [7;8;9;5;35;42;49;21] @@ ap fs1 x;
  assert_equal [7;8;9;35;42;49] @@ ap fs1 y;
  assert_equal [9;7;49;35] @@ ap fs1 z;
  assert_equal [5;7;10;12;11;21;35;56;70;63] @@ ap fs1 a;
  assert_equal [5;21] @@ ap fs1 b;
  assert_equal [] @@ ap fs1 c;

  assert_equal (map pred x) @@ ap fs2 x;
  assert_equal (map pred y) @@ ap fs2 y;
  assert_equal (map pred z) @@ ap fs2 z;
  assert_equal (map pred a) @@ ap fs2 a;
  assert_equal (map pred b) @@ ap fs2 b;
  assert_equal (map pred c) @@ ap fs2 c;

  assert_equal [4;6;5;7;6;8;2;4] @@ flatmap f1 x;
  assert_equal [4;6;5;7;6;8] @@ flatmap f1 y;
  assert_equal [6;8;4;6] @@ flatmap f1 z;
  assert_equal [2;4;4;6;7;9;9;11;8;10] @@ flatmap f1 a;
  assert_equal [2;4] @@ flatmap f1 b;
  assert_equal [] @@ flatmap f1 c;

  assert_equal (map (( * ) 2) x) @@ flatmap f2 x;
  assert_equal (map (( * ) 2) y) @@ flatmap f2 y;
  assert_equal (map (( * ) 2) z) @@ flatmap f2 z;
  assert_equal (map (( * ) 2) a) @@ flatmap f2 a;
  assert_equal (map (( * ) 2) b) @@ flatmap f2 b;
  assert_equal (map (( * ) 2) c) @@ flatmap f2 c

let test_int_tree ctxt =
  let t0 = empty_int_tree in
  let t1 = (int_insert 3 (int_insert 11 t0)) in
  let t2 = (int_insert 13 t1) in
  let t3 = (int_insert 17 (int_insert 3 (int_insert 1 t2))) in

  assert_equal 0 @@ (int_size t0);
  assert_equal 2 @@ (int_size t1);
  assert_equal 3 @@ (int_size t2);
  assert_equal 5 @@ (int_size t3);

  assert_raises (Invalid_argument("int_max")) (fun () -> int_max t0);
  assert_equal 11 @@ int_max t1;
  assert_equal 13 @@ int_max t2;
  assert_equal 17 @@ int_max t3

let test_int_common_1 ctxt =
  let p0 = empty_int_tree in
  let p1 = (int_insert 2 (int_insert 5 p0)) in
  let p3 = (int_insert 10 (int_insert 3 (int_insert 11 p1))) in
  let p4 = (int_insert 15 p3) in
  let p5 = (int_insert 1 p4) in

  assert_equal 5 @@ int_common p5 1 11;
  assert_equal 5 @@ int_common p5 1 10;
  assert_equal 5 @@ int_common p5 2 10;
  assert_equal 2 @@ int_common p5 2 3;
  assert_equal 11 @@ int_common p5 10 11;
  assert_equal 11 @@ int_common p5 11 11

let test_int_common_2 ctxt =
  let q0 = empty_int_tree in
  let q1 = (int_insert 3 (int_insert 8 q0)) in
  let q2 = (int_insert 2 (int_insert 6 q1)) in
  let q3 = (int_insert 12 q2) in
  let q4 = (int_insert 16 (int_insert 9 q3)) in

  assert_equal 3 @@ int_common q4 2 6;
  assert_equal 12 @@ int_common q4 9 16;
  assert_equal 8 @@ int_common q4 2 9;
  assert_equal 8 @@ int_common q4 3 8;
  assert_equal 8 @@ int_common q4 6 8;
  assert_equal 8 @@ int_common q4 12 8;
  assert_equal 8 @@ int_common q4 8 16

let test_ptree_1 ctxt =
  let r0 = empty_ptree Pervasives.compare in
  let r1 = (pinsert 2 (pinsert 1 r0)) in
  let r2 = (pinsert 3 r1) in
  let r3 = (pinsert 5 (pinsert 3 (pinsert 11 r2))) in
  let a = [5;6;8;3;11;7;2;6;5;1]  in
  let x = [5;6;8;3;0] in
  let z = [7;5;6;5;1] in
  let r4a = pinsert_all x r1 in
  let r4b = pinsert_all z r1 in

  let strlen_comp x y = Pervasives.compare (String.length x) (String.length y) in
  let k0 = empty_ptree strlen_comp in
  let k1 = (pinsert "hello" (pinsert "bob" k0)) in
  let k2 = (pinsert "sidney" k1) in
  let k3 = (pinsert "yosemite" (pinsert "ali" (pinsert "alice" k2))) in
  let b = ["hello"; "bob"; "sidney"; "kevin"; "james"; "ali"; "alice"; "xxxxxxxx"] in

  assert_equal [false;false;false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y r0) a;
  assert_equal [false;false;false;false;false;false;true;false;false;true] @@ map (fun y -> pmem y r1) a;
  assert_equal [false;false;false;true;false;false;true;false;false;true] @@ map (fun y -> pmem y r2) a;
  assert_equal [true;false;false;true;true;false;true;false;true;true] @@ map (fun y -> pmem y r3) a;

  assert_equal [false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y k0) b;
  assert_equal [true;true;false;true;true;true;true;false] @@ map (fun y -> pmem y k1) b;
  assert_equal [true;true;true;true;true;true;true;false] @@ map (fun y -> pmem y k2) b;
  assert_equal [true;true;true;true;true;true;true;true] @@ map (fun y -> pmem y k3) b;

  assert_equal [true;true;true;true;true] @@ map (fun y -> pmem y r4a) x;
  assert_equal [true;true;false;false;false] @@ map (fun y -> pmem y r4b) x;
  assert_equal [false;true;true;true;true] @@ map (fun y -> pmem y r4a) z;
  assert_equal [true;true;true;true;true] @@ map (fun y -> pmem y r4b) z

let test_ptree_2 ctxt = 
  let q0 = empty_ptree Pervasives.compare in
  let q1 = pinsert 1 (pinsert 2 (pinsert 0 q0)) in
  let q2 = pinsert 5 (pinsert 11 (pinsert (-1) q1)) in
  let q3 = pinsert (-7) (pinsert (-3) (pinsert 9 q2)) in
  let f = (fun x -> x + 10) in
  let g = (fun y -> y * (-1)) in

  assert_equal [] @@ p_as_list q0;
  assert_equal [0;1;2] @@ p_as_list q1;
  assert_equal [-1;0;1;2;5;11] @@ p_as_list q2;
  assert_equal [-7;-3;-1;0;1;2;5;9;11] @@ p_as_list q3;

  assert_equal [] @@ p_as_list (pmap f q0);
  assert_equal [10;11;12] @@ p_as_list (pmap f q1);
  assert_equal [9;10;11;12;15;21] @@ p_as_list (pmap f q2);
  assert_equal [3;7;9;10;11;12;15;19;21] @@ p_as_list (pmap f q3);

  assert_equal [] @@ p_as_list (pmap g q0);
  assert_equal [-2;-1;0] @@ p_as_list (pmap g q1);
  assert_equal [-11;-5;-2;-1;0;1] @@ p_as_list (pmap g q2);
  assert_equal [-11;-9;-5;-2;-1;0;1;3;7] @@ p_as_list (pmap g q3)

let test_shape ctxt =
  let s0 = Circ {radius=3.0; center={x=5; y=5}} in
  let s1 = Circ {radius=7.0; center={x=1; y=7}} in
  let s2 = Rect {width=2.0; height=9.0; upper={x=3; y=4}} in
  let s3 = Rect {width=11.0; height=8.0; upper={x=0;y=0}} in
  let f x = match x with 
    Circ {radius=_; center=c} -> if c.x > 2 then true else false 
    | Rect {width=_;height=_;upper=u} -> if u.x > 2 then true else false in
  let g y = match y with Circ _ -> true | Rect _ -> false in
  let h z = ((>) (area z) 100.0) in
  let cmp x y = if (area x) < (area y) then (-1) else if (area x) = (area y) then 0 else 1 in

  assert_equal 28 @@ int_of_float (area s0);
  assert_equal 153 @@ int_of_float (area s1);
  assert_equal 18 @@ int_of_float (area s2);
  assert_equal 88 @@ int_of_float (area s3);

  assert_equal [s2;s0] @@ List.sort cmp (filter f [s0;s1;s2;s3]);
  assert_equal [s0;s1] @@ List.sort cmp (filter g [s0;s1;s2;s3]);
  assert_equal [s1] @@ filter h [s0;s1;s2;s3];

  let (l0,u0) = (partition 200.0 [s0;s1;s2;s3]) in
  let (l1,u1) = (partition 120.0 [s0;s1;s2;s3]) in
  let (l2,u2) = (partition 60.0 [s0;s1;s2;s3]) in
  let (l3,u3) = (partition 20.0 [s0;s1;s2;s3]) in
  let (l4,u4) = (partition 10.0 [s0;s1;s2;s3]) in

  assert_equal ([s2;s0;s3;s1],[]) @@ (List.sort cmp l0, u0);
  assert_equal ([s2;s0;s3],[s1]) @@ (List.sort cmp l1, u1);
  assert_equal ([s2;s0],[s3;s1]) @@ (List.sort cmp l2, List.sort cmp u2);
  assert_equal ([s2],[s0;s3;s1]) @@ (l3, List.sort cmp u3);
  assert_equal ([],[s2;s0;s3;s1]) @@ (l4, List.sort cmp u4)

let test_qs ctxt =
  let s0 = Circ {radius=3.0; center={x=5; y=5}} in
  let s1 = Circ {radius=7.0; center={x=1; y=7}} in
  let s2 = Rect {width=2.0; height=9.0; upper={x=3; y=4}} in
  let s3 = Rect {width=11.0; height=8.0; upper={x=0;y=0}} in

  assert_equal [] @@ qs [];
  assert_equal [s0] @@ qs [s0];
  assert_equal [s0;s1] @@ qs [s1;s0];
  assert_equal [s0;s1] @@ qs [s0;s1];
  assert_equal [s2;s0;s1] @@ qs [s0;s1;s2];
  assert_equal [s2;s0;s1] @@ qs [s1;s2;s0];
  assert_equal [s2;s0;s1] @@ qs [s2;s0;s1];
  assert_equal [s2;s0;s3;s1] @@ qs [s0;s1;s2;s3];
  assert_equal [s2;s0;s3;s1] @@ qs [s3;s2;s1;s0];
  assert_equal [s2;s0;s3;s1] @@ qs [s2;s1;s0;s3];
  assert_equal [s2;s0;s3;s1] @@ qs [s2;s0;s3;s1]

let suite =
  "public" >::: [
    "high_order_1" >:: test_high_order_1;
    "high_order_2" >:: test_high_order_2;
    "int_tree" >:: test_int_tree;
    "common_1" >:: test_int_common_1;
    "common_2" >:: test_int_common_2;
    "ptree_1" >:: test_ptree_1;
    "ptree_2" >:: test_ptree_2;
    "shape" >:: test_shape;
    "qs" >:: test_qs
  ]

let _ = run_test_tt_main suite
