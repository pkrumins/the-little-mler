(*
** Chapter 5 of The Little MLer:
** Couples Are Magnificent, Too
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)

(* Another pizza datatype
*)
datatype 'a pizza =
        Bottom
    |   Topping of ('a * ('a pizza));

(* Fishes
*)
datatype fish =
        Anchovy
    |   Lox
    |   Tuna;

(* Example of fish pizza
*)
Topping(Anchovy,
  Topping(Tuna,
    Topping(Anchovy,
      Bottom)));            (* It's type is fish pizza *)

(* Let's write a function that removes Anchovy from the pizza
*)
fun rem_anchovy(Bottom)
    = Bottom
 |  rem_anchovy(Topping(Anchovy, p))
    = rem_anchovy(p)
 |  rem_anchovy(Topping(Lox, p))
    = Topping(Lox, rem_anchovy(p))
 |  rem_anchovy(Topping(Tuna, p))
    = Topping(Tuna, rem_anchovy(p));

(* What's the type of rem_anchovy?
*)
rem_anchovy;                (* It's fish pizza -> fish pizza *)

(* Example of rem_anchovy
*)
rem_anchovy(
  Topping(Lox,
    Topping(Anchovy,
      Topping(Tuna,
        Topping(Anchovy,
          Bottom)))));      (* Topping(Lox, Topping(Tuna, Bottom)) *)

(* Let's make rem_anchovy shorter
*)
fun rem_anchovy2(Bottom)
    = Bottom
 |  rem_anchovy2(Topping(Anchovy, p))
    = rem_anchovy2(p)
 |  rem_anchovy2(Topping(t, p))
    = Topping(t, rem_anchovy2(p));

(* Test rem_anchovy2
*)
rem_anchovy2(
  Topping(Lox,
    Topping(Anchovy,
      Topping(Tuna,
        Topping(Anchovy,
          Bottom)))));      (* Topping(Lox, Topping(Tuna, Bottom)) *)

(* Let's remove Tuna instead of Anchovy
*)
fun rem_tuna(Bottom)
    = Bottom
 |  rem_tuna(Topping(Anchovy, p))
    = Topping(Anchovy,rem_tuna(p))
 |  rem_tuna(Topping(Lox, p))
    = Topping(Lox,rem_tuna(p))
 |  rem_tuna(Topping(Tuna, p))
    = rem_tuna(p);

(* Test rem_tuna
*)
rem_tuna(
  Topping(Tuna,
    Topping(Anchovy,
      Topping(Lox,
        Topping(Tuna,
          Bottom)))));      (* Topping(Anchovy, Topping(Lox, Bottom)) *)

(* What's the type of rem_tuna?
*)
rem_tuna;                   (* It's fish pizza -> fish pizza *)

(* Shortened version of rem_tuna, just like rem_anchovy2
*)
fun rem_tuna2(Bottom)
    = Bottom
 |  rem_tuna2(Topping(Tuna, p))
    = rem_tuna2(p)
 |  rem_tuna2(Topping(t, p))
    = Topping(t, rem_tuna2(p));

(* Test rem_tuna2
*)
rem_tuna2(
  Topping(Tuna,
    Topping(Anchovy,
      Topping(Lox,
        Topping(Tuna,
          Bottom)))));      (* Topping(Anchovy, Topping(Lox, Bottom)) *)

(* Let's generalize removing of fishes and write rem_fish
*)
fun rem_fish(x, Bottom)
    = Bottom
 |  rem_fish(Anchovy, Topping(Anchovy, p))
    = rem_fish(Anchovy, p)
 |  rem_fish(Anchovy, Topping(t, p))
    = Topping(t, rem_fish(Anchovy, p))
 |  rem_fish(Lox, Topping(Lox, p))
    = rem_fish(Lox, p)
 |  rem_fish(Lox, Topping(t, p))
    = Topping(t, rem_fish(Lox, p))
 |  rem_fish(Tuna, Topping(Tuna, p))
    = rem_fish(Tuna, p)
 |  rem_fish(Tuna, Topping(t, p))
    = Topping(t, rem_fish(Tuna,p));

(* What's the type of rem_fish?
*)
rem_fish;                   (* It's (fish, fish pizza) -> fish pizza *)

(* Does it work?
*)
rem_fish(Tuna,
    Topping(Tuna,
      Topping(Anchovy,
        Topping(Lox,
          Topping(Tuna,
            Bottom)))));      (* Topping(Anchovy, Topping(Lox, Bottom)) *)

rem_fish(Anchovy,
    Topping(Tuna,
      Topping(Anchovy,
        Topping(Lox,
          Topping(Tuna,
            Bottom)))));      (* Topping(Tuna, Topping(Lox, Topping(Tuna, Bottom))) *)

(* Let's generalize and make it shorter. First write eq_fish.
*)
fun eq_fish(Anchovy, Anchovy)
    = true
 |  eq_fish(Lox, Lox)
    = true
 |  eq_fish(Tuna, Tuna)
    = true
 | eq_fish(a, b)
    = false;

(* Type of eq_fish is fish*fish -> bool
*)
eq_fish;

(* Let's rewrite rem_fish to use eq_fish
*)
fun rem_fish2(x, Bottom)
    = Bottom
 |  rem_fish2(x, Topping(t, p))
    = if eq_fish(x, t)
        then rem_fish2(x, p)
        else Topping(t,rem_fish2(x,p));

(* Does it work?
*)
rem_fish2(Tuna,
    Topping(Tuna,
      Topping(Anchovy,
        Topping(Lox,
          Topping(Tuna,
            Bottom)))));      (* Topping(Anchovy, Topping(Lox, Bottom)) *)

rem_fish2(Anchovy,
    Topping(Tuna,
      Topping(Anchovy,
        Topping(Lox,
          Topping(Tuna,
            Bottom)))));      (* Topping(Tuna, Topping(Lox, Topping(Tuna, Bottom))) *)

(* Let's do int pizzas!
*)
fun rem_int(x, Bottom)
    = Bottom
 |  rem_int(x, Topping(t, p))
    = if x = t
        then rem_int(x, p)
        else Topping(t, rem_int(x, p));

(* Remove some ints
*)
rem_int(3,
  Topping(2,
    Topping(3,
      Topping(2,
        Bottom))));           (* Topping(2, Topping(2, Bottom)) *)

(* Now let's substitute some fishes!
*)
fun subst_fish(n,a,Bottom)
    = Bottom
 |  subst_fish(n,a,Topping(t,p))
    = if eq_fish(a,t)
        then Topping(n,subst_fish(n,a,p))
        else Topping(t,subst_fish(n,a,p));

(* Let's do this!
*)
subst_fish(Lox, Anchovy,
  Topping(Anchovy,
    Topping(Tuna,
      Topping(Anchovy,
        Bottom))));
(* Topping(Lox, Topping(Tuna, Topping(Lox, Bottom))) *)

(* And substitute ints
*)
fun subst_int(n,a,Bottom)
    = Bottom
 |  subst_int(n,a,Topping(t,p))
    = if a = t
        then Topping(n,subst_int(n,a,p))
        else Topping(t,subst_int(n,a,p));

(* Try it out
*)
subst_int(8, 3,
  Topping(2,
    Topping(3,
      Topping(2,
        Bottom))));     (* Topping(2, Topping(8, Topping(2, Bottom))) *)

(* Remember num from Chapter 1 (01-building-blocks.ss)?
*)
datatype num =
        Zero
    |   One_more_than of num;

(* Let's write a function that determines if two nums are equal
*)
fun eq_num(Zero, Zero)
    = true
 |  eq_num(Zero, One_more_than(x))
    = false
 |  eq_num(One_more_than(x), Zero)
    = false
 |  eq_num(One_more_than(x), One_more_than(y))
    = eq_num(x, y);

(* What's the type of eq_num?
*)
eq_num;                 (* It's num*num -> bool *)

(* Try it out
*)
eq_num(Zero, Zero);                     (* true *)
eq_num(
  One_more_than(One_more_than(Zero)),
  One_more_than(One_more_than(Zero)));  (* true *)
eq_num(
  One_more_than(One_more_than(Zero)),
  One_more_than(Zero));                 (* false *)

(* Can we do a shorter version?
*)
fun eq_num2(Zero, Zero)
    = true
 |  eq_num2(One_more_than(x), One_more_than(y))
    = eq_num2(x, y)
 |  eq_num2(x, y)
    = false;

(* Test eq_num2
*)
eq_num2(Zero, Zero);                     (* true *)
eq_num2(
  One_more_than(One_more_than(Zero)),
  One_more_than(One_more_than(Zero)));  (* true *)
eq_num2(
  One_more_than(One_more_than(Zero)),
  One_more_than(Zero));                 (* false *)

(*****************************************************************************
*                                                                            *
* The fifth moral:                                                           *
*                                                                            *
* Write the first draft of a function following all the morals. When it is   *
* correct and no sooner, simplify.                                           *
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

