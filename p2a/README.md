# Project 2A: OCaml Warmup

Due: September 22 (Late September 23) at 11:59:59 PM

Points: 40P/30R/30S

## Introduction
The goal of this project is to get you familiar with programming in OCaml. You will have to write a number of small functions, each of which is specified in four sections below.

### Ground Rules
In your code, you may **only** use library functions found in the [`Pervasives` module][pervasives doc]. This means you **cannot** use the List module or any other module. You may **not** use any imperative structures of OCaml such as references. The `@` operator is **not** allowed.

### Notes on OCaml
OCaml is a lot different than languages you're likely used to working with, and we'd like to point out a few quirks here that may help you work your way out of common issues with the language.

- Some parts of this project are additive, meaning your solutions to earlier functions can be used to aid in writing later functions. Think about this in Part 3 and Part 4. 
- Unlike most other languages, = in OCaml is the operator for structural equality whereas == is the operator for physical equality. All functions in this project (and in this class, unless ever specified otherwise) are concerned with *structural* equality.
- The subtraction operator (-) also doubles as the negative symbol for `int`s and `float`s in OCaml. As a result, the parser has trouble identifying the difference between subtraction and a negative number. When writing negative numbers, surround them in parentheses. (i.e. `some_function 5 (-10)` works, but `some_function 5 -10` will give an error)

You can run the tests by doing `dune runtest -f`. We recommend you write student tests in `test/student.ml`.

You can run your own tests by doing `dune utop src` (assuming you have `utop`). Then after doing `open Basics` you should be able to use any of the functions.

## Part 1: Non-List Functions
Implement the following functions that do not require knowledge of lists. The first one requires no recursion and the other two require recursion similar to the discussion 3 exercises. You may assume all integer inputs are non-negative.

#### pyth a b c
- **Type**: `int -> int -> int -> bool`
- **Description**: Returns true if `a`, `b`, and `c` are positive integers and satisfy the [Pythagorean Theorem][Pythagorean Theorem], false otherwise.
- **Examples:**
```
pyth 3 4 5 = true
pyth 5 12 13 = true
pyth 1 2 5 = false
```

#### gcd a b
- **Type**: `int -> int -> int`
- **Description**: Returns the greatest common divisor of `a` and `b`. Utilize the [Euclidean Algorithm][Euclidean Algorithm] to accomplish this. 
- **Examples:**
```
gcd 8 12 = 4
gcd 54 24 = 6
gcd 10 0 = 10
gcd 0 10 = 10
gcd 0 0 = 0 
```

#### reduced_form numer denom
- **Type**: `int -> int -> int * int`
- **Description**: Returns the given fraction, as a tuple, in simplest reduced form. Assume denom > 0. (Hint: Use `gcd`.)
- **Examples:**
```
reduced_form 14 10 = (7, 5)
reduced_form 16 4 = (4, 1)
reduced_form 5 7 = (5, 7)
```

#### cubes n
- **Type**: `int -> int`
- **Description**: Returns the sum of cubes from 1 to n. If `n` is less than or equal to zero, you should return zero. i.e.  
![Sum Of Cubes Image][sum of cubes]
- **Examples:**
```
cubes (-3) = 0
cubes 1 = 1
cubes 3 = 36
cubes 6 = 441
```

#### ack m n
- **Type**: `int -> int -> int`
- **Description**: Returns the value of the [Ackermann–Péter function][Ackermann–Péter function] for `m` and `n`. 
- **Examples:**
```
ack 0 0 = 1
ack 0 5 = 6
ack 3 0 = 5
ack 3 3 = 61
```

## Part 2: List Functions
Implement the following simple functions on lists.

#### max_first_three lst
- **Type**: `int list -> int`
- **Description**: Returns the maximum of the first three elements of `lst`, the maximum of all elements if `lst` has less than 3 elements, and -1 if the list is empty.
- **Examples:**
```
max_first_three [] = -1
max_first_three [5] = 5
max_first_three [5; 6] = 6
max_first_three [4; 3; 0] = 4
max_first_three [1; 1; 1; 7] = 1
```

#### count_occ lst target
- **Type**: `int list -> int -> int`
- **Description**: Returns the number of occurrences of `target` in `lst`
- **Examples:**
```
count_occ [] 1 = 0
count_occ [1] 1 = 1
count_occ [1; 2; 2; 1; 3] 1 = 2
```

#### uniq lst
- **Type**: `int list -> int list`
- **Description**: Given a list, returns a list with all duplicate elements removed. If an element appears more than once, only the last appearence should remain in the list.
- **Examples:**
```
uniq [] = []
uniq [1] = [1]
uniq [1; 2; 2; 1; 3] = [2; 1; 3]
```

#### assoc_list lst
- **Type**: `int list -> (int * int) list`
- **Description**: Given a list, returns a list of pairs where the first integer represents the element of the list and the second integer represents the number of occurrences of that element in the list. This associative list should not contain duplicates.
- **Examples:**
```
assoc_list [] = []
assoc_list [1] = [(1,1)]
assoc_list [1; 2; 2; 1; 3] = [(2,2); (1, 2); (3, 1)]
```

#### zip lst
- **Type**: `'a list -> 'b list -> ('a * 'b) list`
- **Description**: Given two lists, returns list of pairs where elements at the same index are paired up in the same order. If one of the lists runs out of elements don't construct any more pairs.
- **Examples:**
```
zip [1;3] [2;4] = [(1,2);(3,4)] 
zip [1;3] [2;4;5] = [(1,2);(3,4)] 
zip [] [5;4;3] = []
zip [] [] = []
```

## Part 3: Set Implementation using Lists
For this part of the project, you will implement sets. In practice, sets are implemented using data structures like balanced binary trees or hash tables. However, your implementation must represent sets using lists. While lists don't lend themselves to the most efficient possible implementation, they are much easier to work with.

For this project, we assume that sets are unordered, homogeneous collections of objects without duplicates. The homogeneity condition ensures that sets can be represented by OCaml lists, which are homogeneous. The only further assumptions we make about your implementation are that the empty list represents the empty set, and that it obeys the standard laws of set theory. For example, if we insert an element `x` into a set `a`, then ask whether `x` is an element of `a`, your implementation should answer affirmatively.

Finally, note the difference between a collection and its implementation. Although *sets* are unordered and contain no duplicates, your implementation using lists will obviously store elements in a certain order and may even contain duplicates. However, there should be no observable difference between an implementation that maintains uniqueness of elements and one that does not; or an implementation that maintains elements in sorted order and one that does not.

Depending on your implementation, you may want to re-order the functions you write. Feel free to do so.

If you do not feel so comfortable with sets see the [Set Wikipedia Page][SetWiki] and/or this [Set Operations Calculator][SetOpCalc].

#### insert x a
- **Type**: `'a -> 'a list -> 'a list`
- **Description**: Inserts `x` into the set `a`.
- **Examples:**
```
insert 2 []
insert 3 (insert 2 [])
insert 3 (insert 3 (insert 2 []))
```

#### elem x a
- **Type**: `'a -> 'a list -> bool`
- **Description**: Returns true iff `x` is an element of the set `a`.
- **Examples:**
```
elem 2 [] = false
elem 3 (insert 5 (insert 3 (insert 2 []))) = true
elem 4 (insert 3 (insert 2 (insert 5 []))) = false
```

#### subset a b
- **Type**: `'a list -> 'a list -> bool`
- **Description**: Return true iff `a` **is a** subset of `b`. Formally, A ⊆ B ⇔ ∀x(xϵA ⇒ xϵB). 
- **Examples:**
```
subset (insert 2 (insert 4 [])) [] = false
subset (insert 5 (insert 3 [])) (insert 3 (insert 5 (insert 2 []))) = true
subset (insert 5 (insert 3 (insert 2 []))) (insert 5 (insert 3 [])) = false
```

#### eq a b
- **Type**: `'a list -> 'a list -> bool`
- **Description**: Returns true iff `a` and `b` are equal as sets. Formally, A = B ⇔ ∀x(xϵA ⇔ xϵB). (Hint: The subset relation is anti-symmetric.)
- **Examples:**
```
eq [] (insert 2 []) = false
eq (insert 2 (insert 3 [])) (insert 3 []) = false
eq (insert 3 (insert 2 [])) (insert 2 (insert 3 [])) = true
```

#### remove x a
- **Type**: `'a -> 'a list -> 'a list`
- **Description**: Removes `x` from the set `a`.
- **Examples:**
```
elem 3 (remove 3 (insert 2 (insert 3 []))) = false
eq (remove 3 (insert 5 (insert 3 []))) (insert 5 []) = true
```

#### union a b
- **Type**: `'a list -> 'a list -> 'a list`
- **Description**: Returns the union of the sets `a` and `b`. Formally, A ∪ B = {x | xϵA ∨ xϵB}.
- **Examples:**
```
eq (union [] (insert 2 (insert 3 []))) (insert 3 (insert 2 [])) = true
eq (union (insert 5 (insert 2 [])) (insert 2 (insert 3 []))) (insert 3 (insert 2 (insert 5 []))) = true
eq (union (insert 2 (insert 7 [])) (insert 5 [])) (insert 5 (insert 7 (insert 2 []))) = true
```

#### intersection a b
- **Type**: `'a list -> 'a list -> 'a list`
- **Description**: Returns the intersection of sets `a` and `b`. Formally, A ∩ B = {x | xϵA ∧ xϵB}.
- **Examples:**
```
eq (intersection (insert 3 (insert 5 (insert 2 []))) []) [] = true
eq (intersection (insert 5 (insert 7 (insert 3 (insert 2 [])))) (insert 6 (insert 4 []))) [] = true
eq (intersection (insert 5 (insert 2 [])) (insert 4 (insert 3 (insert 5 [])))) (insert 5 []) = true
```

#### product a b
- **Type**: `'a list -> 'b list -> ('a * 'b) list`
- **Description**: Returns the Cartesian product of sets `a` and `b`. Formally, A × B = {(x,y) | xϵA ∧ yϵB}. (Hint: You may find it useful to write a helper function.)
- **Examples:**
```
eq (product [] []) [] = true
eq (product (insert 2 []) []) [] = true
eq (product (insert 2 []) (insert 2 [])) (insert (2,2) []) = true
eq (insert (2,3) (insert (2,9) [])) (product (insert 2 []) (insert 3 (insert 9 []))) = true
``` 
 
## Academic Integrity
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[pervasives doc]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Pervasives.html
[git instructions]: ../git_cheatsheet.md
[submit server]: https://submit.cs.umd.edu
[web submit link]: ../common-images/web_submit.jpg
[web upload example]: ../common-images/web_upload.jpg
[Pythagorean Theorem]: https://en.wikipedia.org/wiki/Pythagorean_theorem
[sum of cubes]: images/sum-of-cubes.png
[Euclidean Algorithm]: https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm
[Ackermann–Péter function]:https://en.wikipedia.org/wiki/Ackermann_function
[SetOpCalc]: https://www.mathportal.org/calculators/misc-calculators/sets-calculator.php
[SetWiki]:https://en.wikipedia.org/wiki/Set_(mathematics)#External_links
