val pyth : int -> int -> int -> bool
val gcd: int -> int -> int
val reduced_form : int -> int -> int * int
val cubes : int -> int
val ack: int -> int -> int

val max_first_three : int list -> int
val count_occ : 'a list -> 'a -> int
val uniq : 'a list -> 'a list
val assoc_list : 'a list -> ('a * int) list
val zip : 'a list -> 'b list -> ('a * 'b) list

val elem : 'a -> 'a list -> bool
val insert : 'a -> 'a list -> 'a list
val subset : 'a list -> 'a list -> bool
val eq : 'a list -> 'a list -> bool
val remove : 'a -> 'a list -> 'a list
val union : 'a list -> 'a list -> 'a list
val intersection : 'a list -> 'a list -> 'a list
val product : 'a list -> 'b list -> ('a * 'b) list
