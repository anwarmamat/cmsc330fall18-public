# Project 2B: OCaml Higher Order Functions and Data
Due: October 2 (Late October 3) at 11:59:59 PM
Points: 65P/35R/0S

## Introduction
The goal of this project is to increase your familiarity with programming in OCaml and give you practice using higher order functions and user-defined types. You will have to write a number of small functions, the specifications of which are given below. Some of them start out as code we provide you. In our reference solution, each function typically requires writing or modifying 1-8 lines of code.

You should be able to complete Part 1 after the lecture on high-order functions and the remaining sections after the lecture on user-defined types.

### Ground Rules
In your code, you may **only** use library functions found in the [`Pervasives` module][pervasives doc] and the functions provided in `funs.ml`. You **may** use the `@` operator. You **cannot** use the `List` module. You **may not** use any imperative structures of OCaml such as references.

There are public tests that check you did not use any features that were not allowed. They aren't worth any points, but you will **lose** points if you fail these tests. 

At a few points in this project, you will need to raise an `Invalid_argument` exception. Use the `invalid_arg` function to do so:
```
invalid_arg "something went wrong"
```
Use the error message that the function specifies as the argument. 

You can run the tests by doing `dune runtest -f`. We recommend you write student tests in `test/student.ml`.

You can run your own tests by doing `dune utop src` (assuming you have `utop`). Then after doing `open P2b.Higher` and `open P2b.Data` you should be able to use any of the functions.

## Part 1: High Order Functions
Write the following functions in `higher.ml` using `map`, `fold`, or `fold_right` as defined in the file `funs.ml`. Do not modify `funs.ml`, your changes will not be reflected on the submit server. You **must** use `map`, `fold`, or `fold_right` to complete these functions, so no functions in `higher.ml` should be defined using the `rec` keyword. You will lose points if this rule is not followed. Use the other provided functions in `funs.ml` to make completing the functions easier. 

Some of these functions will require just map or fold, but some will require a combination of the two. The map/reduce design pattern may come in handy: Map over a list to convert it to a new list which you then process a second time using fold. The idea is that you first process the list using map, and then reduce the resulting list using fold.


#### count_occ lst target
- **Type**: `'a list -> 'a -> int`
- **Description**: Returns how many elements in `lst` are equal to `target`.
- **Examples:**
```
count_occ [] 1 = 0
count_occ [1] 1 = 1
count_occ [1; 2; 2; 1; 3] 1 = 2
```

#### uniq lst
- **Type**: `'a list -> 'a list`
- **Description**: Given a list, returns a list with all duplicate elements removed. May be returned in any order.
- **Examples:**
```
uniq [] = []
uniq [1] = [1]
uniq [1; 2; 2; 1; 3] = [2; 1; 3]
```

#### assoc_list lst
- **Type**: `'a list -> ('a * int) list`
- **Description**: Given a list, returns a list of pairs where the first integer represents the element of the list and the second integer represents the number of occurrences of that element in the list. This associative list should not contain duplicates and may be returned in any order.
- **Examples:**
```
assoc_list [] = []
assoc_list [1] = [(1,1)]
assoc_list [1; 2; 2; 1; 3] = [(2,2); (1, 2); (3, 1)]
```

#### flatmap f lst
- **Type**: `('a -> 'b list) -> 'a list -> 'b list`
- **Description**: Applies the function `f` to all elements in `lst` and then concatenates the results into a single list.
- **Examples:**
```
flatmap (fun x -> []) [1;2;3;4] = []
flatmap (fun x -> [(succ x)]) [] = []
flatmap (fun x -> [x^"?";x^"!"]) ["foo";"bar"] = ["foo?";"foo!";"bar?";"bar!"]
flatmap (fun x -> [(pred x);(succ x)]) [1;2] = [0;2;1;3]
flatmap (fun x -> [int_of_float x;(int_of_float x)*2]) [1.0;2.0;3.0] = [1; 2; 2; 4; 3; 6]

```

#### ap fns args
- **Type**: `('a -> 'b) list -> 'a list -> 'b list`
- **Description**: Applies each function in `fns` to each argument in `args` in order.
- **Examples:**
```
ap [] [1;2;3;4] = []
ap [succ] [] = []
ap [(fun x -> x^"?"); (fun x -> x^"!")] ["foo";"bar"] = ["foo?";"bar?";"foo!";"bar!"]
ap [pred;succ] [1;2] = [0;1;2;3]
ap [int_of_float;fun x -> (int_of_float x)*2] [1.0;2.0;3.0] = [1; 2; 3; 2; 4; 6]

```

Note the types of `map`, `ap`, and `flatmap`. Do you see the similarities?

```
map : ('a -> 'b) -> 'a list -> 'b list
ap : ('a -> 'b) list -> 'a list -> 'b list
flatmap : ('a -> 'b list) -> 'a list -> 'b list
```

## Part 2: Integer BST
The remaining sections will be implemented in `data.ml`.

Here, you will write functions that will operate on a binary search tree whose nodes contain integers. Provided below is the type of `int_tree`.

```
type int_tree =
    IntLeaf
  | IntNode of int * int_tree * int_tree
```

According to this definition, an ``int_tree`` is either: empty (just a leaf), or a node (containing an integer, left subtree, and right subtree). An empty tree is just a leaf.

```
let empty_int_tree = IntLeaf
```

Like lists, BSTs are immutable. Once created we cannot change it. To insert an element into a tree, create a new tree that is the same as the old, but with the new element added. Let's write `insert` for our `int_tree`. Recall the algorithm for inserting element `x` into a tree:

- *Empty tree?* Return a single-node tree.
- `x` *less than the current node?* Return a tree that has the same content as the present tree but where the left subtree is instead the tree that results from inserting `x` into the original left subtree.
- `x` *already in the tree?* Return the tree unchanged.
- `x` *greater than the current node?* Return a tree that has the same content as the present tree but where the right subtree is instead the tree that results from inserting `x` into the original right subtree.

Here's one implementation:

```
let rec int_insert x t =
  match t with
    IntLeaf -> IntNode (x, IntLeaf, IntLeaf)
  | IntNode (y, l, r) when x < y -> IntNode (y, int_insert x l, r)
  | IntNode (y, l, r) when x = y -> t
  | IntNode (y, l, r) -> IntNode (y, l, int_insert x r)
```

**Note**: The `when` syntax may be unfamiliar to you - it acts as an extra guard in addition to the pattern. For example, `IntNode (y, l, r) when x < y` will only be matched when the tree is an `IntNode` and `x < y`. This serves a similar purpose to having an if statement inside of the general `IntNode` match case, but allows for more readable syntax in many cases.

Let's try writing a function which determines whether a tree contains an element. This follows a similar procedure except we'll be returning a boolean if the element is a member of the tree.

```
let rec int_mem x t =
  match t with
    IntLeaf -> false
  | IntNode (y, l, r) when x < y -> int_mem x l
  | IntNode (y, l, r) when x = y -> true
  | IntNode (y, l, r) -> int_mem x r
```

It's your turn now! Write the following functions which operate on `int_tree`.

#### int_size t
- **Type**: `int_tree -> int`
- **Description**: Returns the number of nodes in tree `t`.
- **Examples:**
```
int_size empty_int_tree = 0
int_size (int_insert 1 (int_insert 2 empty_int_tree)) = 2
```

#### int_max t
- **Type**: `int_tree -> int`
- **Description**: Returns the maximum element in tree `t`. Raises exception `Invalid_argument("int_max")` on an empty tree. This function should be O(height of the tree).
- **Examples:**
```
int_max (int_insert_all [1;2;3] empty_int_tree) = 3
```

#### int_common t x y
- **Type**: `int_tree -> int -> int -> int`
- **Description**: Returns the closest common ancestor of `x` and `y` in the tree `t` (i.e. the lowest shared parent in the tree). Raises exception `Invalid_argument("int_common")` on an empty tree or where `x` or `y` don't exist in tree `t`.
- **Examples:**
```
let t = int_insert_all [6;1;8;5;10;13;9;4] empty_int_tree;;
int_common t 1 10 = 6
int_common t 8 9 = 8
```

## Part 3: Polymorphic BST
Our type `int_tree` is limited to integer elements. We want to define a binary search tree over *any* totally ordered type. Let's define the type `'a atree` to do so.

```
type 'a atree =
    Leaf
  | Node of 'a * 'a atree * 'a atree
```

This defintion is the same as `int_tree` except it's polymorphic. The nodes may contain any type `'a`, not just integers. Since a tree may contain any value, we need a way to compare values. We define a type for comparison functions.

```
type 'a compfn = 'a -> 'a -> int
```

Any comparison function will take two `'a` values and return an integer. If the integer is negative, the first value is less than the second; if positive, the first value is greater; if 0 they're equal.

Finally, we can bundle the two previous types to create a polymorphic BST.

```
type 'a ptree = 'a compfn * 'a atree
```

An empty tree is just a leaf and some comparison function.

```
let empty_ptree f : 'a ptree = (f, Leaf)
```

You can modify the code from your `int_tree` functions to implement some functions on `ptree`. Remember to use the bundled comparison function!

#### pinsert x t
- **Type**: `'a -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree which is the same as tree `t`, but with `x` added to it.
- **Examples:**
```
let int_comp x y = if x < y then -1 else if x > y then 1 else 0;;
let t0 = empty_ptree int_comp;;
let t1 = pinsert 1 (pinsert 8 (pinsert 5 t0));;
```

#### pmem x t
- **Type**: `'a -> 'a ptree -> bool`
- **Description**: Returns true iff `x` is an element of tree `t`.
- **Examples:**
```
(* see definitions of t0 and t1 above *)
pmem 5 t0 = false
pmem 5 t1 = true
pmem 1 t1 = true
pmem 2 t1 = false
```

#### pinsert_all lst t
- **Type**: `'a list -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree which is the same as tree `t`, but with all the elements in list `lst` added to it. Try to use fold to implement this in one line.
- **Examples:**
```
p_as_list (pinsert_all [1;2;3] t0) = [1;2;3]
p_as_list (pinsert_all [1;2;3] t1) = [1;2;3;5;8]
```

#### p_as_list t
- **Type**: `'a ptree -> 'a list`
- **Description**: Returns a list where the values correspond to an [in-order traversal][wikipedia inorder traversal] on tree `t`.
- **Examples:**
```
p_as_list (pinsert 2 (pinsert 1 t0)) = [1;2]
p_as_list (p_insert 2 (p_insert 2 (p_insert 3 t0))) = [2;3]
```

#### pmap f t
- **Type**: `('a -> 'a) -> 'a ptree -> 'a ptree`
- **Description**: Returns a tree where the function `f` is applied to all the elements of `t`.
- **Examples:**
```
p_as_list (pmap (fun x -> x * 2) t1) = [2;10;16]
p_as_list (pmap (fun x -> x * (-1)) t1) = [-8;-5;-1]
```

## Part 4: Shapes with Records
For the last part of this project, you will implement functions which operate on shapes.

Here are the types for shapes. They use OCaml's record syntax.

```
type pt = { x: int; y: int }
type shape = 
    Circ of { radius: float; center: pt }
  | Rect of { width: float; height: float; upper: pt }
```

A pt is record with two fields: an x and y coordinate (both represented as ints). A shape can either be a Circ (a record with two fields for radius and center point) or a Rect (a record with three fields for width, height, and upper left coordinate). 

Write the following functions which operate on `shape`.

#### area s
- **Type**: `shape -> float`
- **Description**: Returns the area of the shape. When computing the area of a circle, use the 3.14 as the definition of pi.
- **Examples:**
```
let s0 = Circ { radius = 2.0; center = { x = 5; y = 0 } }
let s1 = Rect { width = 4.0; height = 8.0; upper = { x = 0; y = 3 } }
let s2 = Circ { radius = 10.0; center = { x = 1; y = 1 } }
area s0 = 12.56
area s1 = 32.0
area s2 = 314.0
```

#### filter f lst
- **Type**: `(shape -> bool) -> shape list -> shape list`
- **Description**: Returns a list of all the shapes in `lst` that satisfy the predicate function `f`.
- **Examples:**
```
(* see definitions of s0 and s1 above *)
filter (fun x -> match x with Circ _ -> true | Rect _ -> false) [s0;s1] = [s0]
```

#### partition thresh lst
- **Type**: `float -> shape list -> (shape list * shape list)`
- **Description**: Returns a tuple where the first part of the pair is a list of shapes from `lst` that have an area less than `thresh` and the second part of the pair is a list of shapes that have an area greater than or equal to `thresh`.
- **Examples:**
```
partition 20.0 [s0;s1] = ([s0],[s1])
partition 10.0 [s0;s1] = ([],[s0;s1])
partition 40.0 [s0;s1] = ([s0;s1],[])
```

#### qs lst
- **Type**: `shape list -> shape list`
- **Description**: Returns the list of shapes quicksorted by their areas.
- **Examples:**
```
qs [s1;s2;s0] = [s0;s1;s2]
qs [s2;s1;s0] = [s0;s1;s2]
```

## Academic Integrity
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[pervasives doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
[git instructions]: ../git_cheatsheet.md
[wikipedia inorder traversal]: https://en.wikipedia.org/wiki/Tree_traversal#In-order
[submit server]: submit.cs.umd.edu
[web submit link]: image-resources/web_submit.jpg
[web upload example]: image-resources/web_upload.jpg
