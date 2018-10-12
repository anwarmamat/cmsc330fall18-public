let rec smush lst = match lst with
| [] -> ""
| h :: t -> h ^ (smush t)

let smush_tr lst = failwith "unimplemented"

let rec fib_reg n =
  if n = 1 || n = 2 then
    1
  else
    fib_reg (n - 2) + fib_reg (n - 1)

let fib_tr n =
  failwith "unimplemented"

