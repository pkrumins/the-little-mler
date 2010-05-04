(*
** Chapter 9 of The Little MLer:
** Oh No!
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)

Control.Print.printDepth := 20;

(* Lists
*)
datatype 'a list =
    Empty
 |  Cons of 'a * 'a list;

(* Bacon and index
*)
datatype box =
    Bacon
 |  Ix of int;

(* Is bacon?
*)
fun is_bacon(Bacon)
    = true
 |  is_bacon(Ix(y))
    = false;                                (* box -> bool *)

(* Where is bacon?
*)
fun where_is(Empty)
    = 0
 |  where_is(Cons(a_box, rest))
    = if is_bacon(a_box)
        then 1
        else 1 + where_is(rest);            (* box list -> int *)

(* But it's wrong.
*)
where_is(
  Cons(Ix(5),
    Cons(Ix(13),
      Cons(Ix(8),
        Empty))));                          (* 3, but should be 0 *)

(* Exceptions to the rescue
*)
exception No_bacon of int;

fun where_is(Empty)
    = raise No_bacon(0)
 |  where_is(Cons(a_box, rest))
    = if is_bacon(a_box)
        then 1
        else 1 + where_is(rest);

(* Now what happens?
*)
(*
where_is(
  Cons(Ix(5),
    Cons(Ix(13),
      Cons(Ix(8),
        Empty))));                          (* uncaught exception! *)
*)

(* Let's handle the exception
*)
(where_is(
  Cons(Ix(5),
    Cons(Ix(13),
      Cons(Ix(8),
        Empty))))
  handle
    No_bacon(an_int)
    => an_int);                             (* 0 *)

(* Now without an exception
*)
(where_is(
  Cons(Ix(5),
    Cons(Ix(13),
      Cons(Bacon,
        Empty))))
  handle
    No_bacon(an_int)
    => an_int);                             (* 3 *)

(* Let's play find the bacon.
*)
exception Out_of_range;

fun list_item(n, Empty)
    = raise Out_of_range
 |  list_item(n, Cons(a,b))
    = if n = 1
        then a
        else list_item(n-1, b);             (* int * 'a list -> 'a *)

fun find(n,boxes)
    = check(n,boxes,list_item(n,boxes))     (* int * box list -> int *)
and
    check(n,boxes, Bacon)
    = n
 |  check(n, boxes, Ix(i))
    = find(i, boxes);                       (* int * box list * box -> int *)

(* Try it out.
*)
val t =
  Cons(Ix(5),
    Cons(Ix(4),
      Cons(Bacon,
        Cons(Ix(2),
          Cons(Ix(7),
            Empty)))));

(*
find(1,t);                                  (* Out_of_range *)
*)

(* No good, let's modify find to handle exceptions.
*)
fun find(n,boxes)
    = (check(n,boxes,list_item(n,boxes))
       handle
         Out_of_range
         => find(n div 2, boxes))           (* int * box list -> int *)
and
    check(n,boxes, Bacon)
    = n
 |  check(n, boxes, Ix(i))
    = find(i, boxes);                       (* int * box list * box -> int *)

(* Now what?
*)
find(1, t);                                 (* 3 *)

(* Let's find the path we took.
*)
fun path(n, boxes)
    = Cons(n,
        (check(boxes, list_item(n,boxes))
         handle
         Out_of_range
         => path(n div 2, boxes)))          (* int * box list -> int list *)
and
    check(boxes, Bacon)
    = Empty
 |  check(boxes, Ix(i))
    = path(i, boxes);                       (* box list * box -> int list *)

(* Try it.
*)
path(1, t);                                 (* 1 5 7 3 *)

(* It doesn't quite work
*)
val u =
  Cons(Ix(5),
    Cons(Ix(4),
      Cons(Ix(1),
        Cons(Ix(2),
          Cons(Ix(7),
            Empty)))));

(*
path(1,u);                                  (* infinite loop *)
*)

(*****************************************************************************
*                                                                            *
* The ninth moral:                                                           *
*                                                                            *
* Some functions produce exceptions instead of values; some don't produce    *
* anything. Handle raised exceptions carefully.                              *
*                                                                            *
*****************************************************************************)


(*
** Go get yourself this wonderful book and have fun with ML!
**
** Shortened URL to the book at Amazon.com: http://bit.ly/aNenRl
**
** Sincerely,
** Peteris Krumins
** http://www.catonmat.net
*)

