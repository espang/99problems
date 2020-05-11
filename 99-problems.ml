

(* Write a function that returns the last element of a list *)
let rec last xs = 
  match xs with
    | [] -> None
    | [x] -> Some x
    | _ :: t -> last t

let rec last_two xs = 
  match xs with
    | [] -> None
    | [_] -> None
    |  [x;_] -> Some x
    | _ :: t -> last_two t

let rec kth k xs =
  match xs with
  | [] -> None
  | h :: t -> if k = 1 then Some h else kth (k-1) t

let count xs =
  let rec helper = fun xs acc ->
    match xs with 
    | [] -> acc
    | _ :: t -> helper t (acc+1)
  in
    helper xs 0

let reverse xs =
  let rec helper = fun xs acc ->
    match xs with
    | [] -> acc
    | h :: t -> helper t (h :: acc)
  in
    helper xs []

let palindrome xs = 
  xs = reverse xs

type 'a node =
  | One of 'a 
  | Many of 'a node list

let nested_list =
  [ One "a" ; Many [ One "b" ; Many [ One "c" ; One "d" ] ; One "e" ] ]

let flatten xs =
  let rec helper = fun xs acc ->
    match xs with
    | [] -> acc
    | One x :: t -> helper t (x :: acc)
    | Many h :: t -> helper t (helper h acc)
  in
    reverse (helper xs [])

let rec compress xs = 
  match xs with
  | (a :: (b :: _ as t)) -> if a = b then compress t else a :: compress t
  | x -> x

let pack xs =
  let rec helper = fun xs x cur acc ->
    match xs with
    | [] -> reverse (cur :: acc)
    | h :: t -> if x = h 
                then helper t x (x :: cur) acc
                else helper t h [h] (cur :: acc)
  in
    match xs with
    | [] -> []
    | h :: t -> helper t h [h] []

let encode xs =
  let rec helper = fun xs (x, c) acc ->
    match xs with
    | [] -> reverse ((x, c) :: acc)
    | h :: t -> if x = h
                then helper t (x, (c+1)) acc
                else helper t (h, 1) ((x, c) :: acc)
  in
    match xs with
    | [] -> []
    | h :: t -> helper t (h, 1) []

type 'a rle =
  | ROne of 'a
  | RMany of int * 'a;;

let make_rle x c =
  match c with
  | 1 -> ROne x
  | _ -> RMany (c, x)

let encode2 xs =
  let rec helper = fun xs (x, c) acc ->
    match xs with
    | [] -> reverse ((make_rle x c) :: acc)
    | h :: t -> if x = h
                then helper t (x, (c+1)) acc
                else helper t (h, 1) ((make_rle x c) :: acc)
  in
    match xs with
    | [] -> []
    | h :: t -> helper t (h, 1) []
  