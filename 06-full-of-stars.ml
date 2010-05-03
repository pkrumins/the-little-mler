(*
** Chapter 6 of The Little MLer:
** Oh My, It's Full of Stars!
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)

Control.Print.printDepth := 20;

(* Fruits
*)
datatype fruit =
        Peach
    |   Apple
    |   Pear
    |   Lemon
    |   Fig;

(* Now the trees
*)
datatype tree =
        Bud
    |   Flat of fruit*tree
    |   Split of tree*tree;

(* Determine if a tree is flat
*)
fun flat_only(Bud)
    = true
 |  flat_only(Flat(f, t))
    = flat_only(t)
 |  flat_only(Split(s, t))
    = false;

(* The datatype of flat_only is tree -> bool
*)
flat_only;

(* Examples of flat_only
*)
flat_only(
  Flat(Apple,
    Flat(Peach,
      Bud)));                       (* true *)

flat_only(Flat(Pear, Bud));         (* true *)

flat_only(
  Split(
    Bud,
    Flat(Fig,
      Split(Bud,
        Bud))));                    (* false *)

(* split_only checks whether a tree is constructed with Split and Bud only
*)
fun split_only(Bud)
    = true
 |  split_only(Flat(f, t))
    = false
 |  split_only(Split(s, t))
    = if split_only(t)            (* this could also have been written as: *)
        then split_only(s)        (* split_only(s) andalso split_only(t)   *)
        else false;

(* Is split_only also tree -> bool?
*)
split_only;                         (* yes, it is *)

(* Example of split_only
*)
split_only(
  Split(
    Split(
      Bud,
      Split(
        Bud,
        Bud)),
    Split(
      Bud,
      Split(
        Bud,
        Bud))));                    (* true *)

split_only(
  Split(
    Bud,
    Split(
      Flat(Fig, Bud),
      Flat(Fig, Bud))));            (* false *)

(* Does a tree contain any fruit?
*)
fun contains_fruit(Bud)
    = false
 |  contains_fruit(Flat(f, t))
    = true
 |  contains_fruit(Split(s, t))
    = if contains_fruit(s)
        then true
        else contains_fruit(t);

(* Example of contains_fruit
*)
contains_fruit(
  Flat(Apple,
    Flat(Peach,
      Bud)));                       (* true *)

contains_fruit(
  Split(
    Bud,
    Bud));                          (* false *)

(* height needs larger_of helper function
*)
fun larger_of(a, b)
    = if a > b
        then a
        else b;

(* What's the height of a tree?
*)
fun height(Bud)
    = 0
 |  height(Flat(f, t))
    = 1 + height(t)
 |  height(Split(s, t))
    = 1 + larger_of(height(s), height(t));

(* Examples of height
*)
height(
  Split(
    Split(
      Bud,
      Flat(Lemon, Bud)),
    Flat(
      Fig,
      Split(
        Bud,
        Bud))));                    (* 3 *)

height(
  Split(
    Bud,
    Flat(Lemon, Bud)));             (* 2 *)

height(
  Flat(Lemon, Bud));                (* 1 *)

height(Split(Bud, Bud));            (* 1 *)

height(Bud);                        (* 0 *)

(* Substitute one fruit for another
*)
fun subst_in_tree(new_fruit, old_fruit, Bud)
    = Bud
 |  subst_in_tree(new_fruit, old_fruit, Flat(f, t))
    = if f = old_fruit
        then Flat(new_fruit, subst_in_tree(new_fruit, old_fruit, t))
        else Flat(f, subst_in_tree(new_fruit, old_fruit, t))
 |  subst_in_tree(new_fruit, old_fruit, Split(s, t))
    = Split(subst_in_tree(new_fruit, old_fruit, s),
            subst_in_tree(new_fruit, old_fruit, t));

(* What is the datatype of subst_in_tree?
*)
subst_in_tree;                      (* It's fruit*fruit*tree -> tree *)

(* Example of subst_in_tree
*)
subst_in_tree(
  Apple, Fig,
  Split(
    Split(
      Flat(Fig, Bud),
      Flat(Fig, Bud)),
    Flat(Fig,
      Flat(Lemon,
        Flat(Apple, Bud)))));       (* You figure it out *)

(* Determine how many times does a Fruit appear in a tree
*)
fun occurs(a, Bud)
    = 0
 |  occurs(a, Flat(f, t))
    = if a = f
        then 1 + occurs(a, t)
        else occurs(a, t)
 |  occurs(a, Split(s, t))
    = occurs(a,s) + occurs(a,t);

(* Example of occurs
*)
occurs(Fig,
  Split(
    Split(
      Flat(Fig, Bud),
      Flat(Fig, Bud)),
    Flat(Fig,
      Flat(Lemon,
        Flat(Apple,
          Bud)))));                 (* 3 *)

(* And now for something new
*)
datatype 
    'a slist =
            Empty
        |   Scons of (('a sexp)*('a slist))
and
    'a sexp =
            An_atom of 'a
        |   A_slist of ('a slist);

(* Examples of this datatype
*)
An_atom(5);                         (* int sexp *)
An_atom(Fig);                       (* fruit sexp *)
A_slist(Empty);                     (* 'a sexp *)

Scons(An_atom(5),
  Scons(An_atom(13),
    Scons(An_atom(1), Empty)));     (* int slist *)

Scons(An_atom(Fig), Empty);         (* fruit slist *)

(* Count how many times something occurs in the new datastructure
*)
fun occurs_in_slist(a, Empty)
    = 0
 |  occurs_in_slist(a, Scons(x, y))
    = occurs_in_sexp(a, x) +
      occurs_in_slist(a, y)
and
    occurs_in_sexp(a, An_atom(b))
    = if a = b
        then 1
        else 0
 |  occurs_in_sexp(a, A_slist(y))
    = occurs_in_slist(a, y);

(* What's the datatype of occurs_in_slist?
*)
occurs_in_slist;                    (* ''a * ''a slist -> int *)

(* What's the datatype of occurs_in_sexp?
*)
occurs_in_sexp;                     (* ''a * ''a sexp -> int *)

(* Try it out.
*)
occurs_in_slist(Fig,
  Scons(An_atom(Fig),
    Scons(An_atom(Fig),
      Scons(An_atom(Lemon),
        Empty))));                  (* 2 *)

occurs_in_sexp(Fig,
  A_slist(
    Scons(An_atom(Fig),
      Scons(An_atom(Peach),
        Empty))));                  (* 1 *)

(* Substitute one item for a different one in slist and sexp
*)
fun subst_in_slist(n, a, Empty)
    = Empty
 |  subst_in_slist(n, a, Scons(x, y))
    = Scons(
        subst_in_sexp(n, a, x),
        subst_in_slist(n, a, y))
and
    subst_in_sexp(n, a, An_atom(x))
    = if a = x
        then An_atom(n)
        else An_atom(x)
|
    subst_in_sexp(n, a, A_slist(y))
    = A_slist(subst_in_slist(n, a, y));

(* Datatype of subst_in_slist
*)
subst_in_slist;                     (* ''a * ''a * ''a slist -> ''a slist *)

(* Datatype of subst_in_sexp
*)
subst_in_sexp;                      (* ''a * ''a * ''a sexp -> ''a sexp *)

(* Try it out.
*)
subst_in_slist(Fig, Lemon,
  Scons(An_atom(Lemon),
    Scons(An_atom(Lemon),
      Scons(An_atom(Fig), 
        Scons(An_atom(Peach),
          Empty)))));               (* Fig, Fig, Fig, Peach *)

subst_in_sexp(Fig, Lemon,
  A_slist(
    Scons(An_atom(Lemon),
      Scons(A_slist(
              Scons(An_atom(Lemon),
                Empty)), Empty)))); (* Fig, Fig *)
        
(* Define eq_in_atom helper function
*)
fun eq_in_atom(a, An_atom(y))
    = a = y
 |  eq_in_atom(a, A_slist(s))
    = false;

(* Let's remove atoms
*)
fun rem_from_slist(a, Empty)
    = Empty
 |  rem_from_slist(a, Scons(x, y))
    = if eq_in_atom(a, x)
        then rem_from_slist(a, y)
        else Scons(
               rem_from_sexp(a, x),
               rem_from_slist(a, y))
and
    rem_from_sexp(a, An_atom(x))
    = An_atom(x)
 |  rem_from_sexp(a, A_slist(y))
    = A_slist(rem_from_slist(a, y));

(* Try it out.
*)
rem_from_slist(Fig,
  Scons(An_atom(Fig),
    Scons(An_atom(Lemon),
      Empty)));                     (* Scons(An_atom(Lemon, Empty)) *)

(* Another way to remove elements in a more elegant manner
*)
fun rem_from_slist2(a, Empty)
    = Empty
 |  rem_from_slist2(a, Scons(An_atom(x), y))
    = if a = x
        then rem_from_slist2(a, y)
        else Scons(
               An_atom(x),
               rem_from_slist2(a, y))
 |  rem_from_slist2(a, Scons(A_slist(x), y))
    = Scons(
        A_slist(
          rem_from_slist2(a, x)),
          rem_from_slist2(a, y));

(* Try it out.
*)
rem_from_slist2(Fig,
  Scons(An_atom(Fig),
    Scons(An_atom(Lemon),
      Empty)));                     (* Scons(An_atom(Lemon, Empty)) *)

(*****************************************************************************
*                                                                            *
* The sixth moral:                                                           *
*                                                                            *
* As datatype definitions get more compicated, so do the functions over      *
* them.                                                                      *
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

