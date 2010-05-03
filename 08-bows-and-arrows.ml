(*
** Chapter 8 of The Little MLer:
** Bows and Arrows
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)


(* 'a lists
*)
datatype 'a list =
    Empty
 |  Cons of 'a * 'a list;

(* Also oranges and apples.
*)
datatype orapl =
    Orange
 |  Apple;

(* A comparsion function for oranges and apples
*)
fun eq_orapl(Oragne, Orange)
    = true
 |  eq_orapl(Apple, Apple)
    = true
 |  eq_orapl(a, b)
    = false;

(* It's type
*)
eq_orapl;                               (* (orapl*orapl) -> bool *)

(* eq_int helper
*)
fun eq_int(x:int,y:int)
    = x=y;

(* Let's substitute some ints
*)
fun subst_int(n,a,Empty)
    = Empty
 |  subst_int(n,a,Cons(e,t))
    = if eq_int(e,a)
        then Cons(n,subst_int(n,a,t))
        else Cons(e,subst_int(n,a,t));

(* Try it out.
*)
subst_int(10,1,Cons(5,Cons(4,Cons(3,Cons(2,Cons(1,Empty))))));

(* What is its type?
*)
subst_int;                              (* int*int*int list -> int list *)

(* Now let's substitute some oranges
*)
fun subst_orapl(n,a,Empty)
    = Empty
 |  subst_orapl(n,a,Cons(e,t))
    = if eq_orapl(e,a)
        then Cons(n,subst_orapl(n,a,t))
        else Cons(e,subst_orapl(n,a,t));

(* Try it out.
 * *)
subst_orapl(Orange,Apple,Cons(Apple,Cons(Orange,Cons(Apple,Empty))));

(* What is its type?
 * *)
subst_orapl;                    (* orapl*orapl*orapl list -> orapl list *)

(* This is duplication, let's abstract it *)

fun subst(rel,n,a,Empty)
    = Empty
 |  subst(rel,n,a,Cons(e,t))
    = if rel(a,e)
        then Cons(n,subst(rel,n,a,t))
        else Cons(e,subst(rel,n,a,t));

(* What's its type?
*)
subst;                  (* ('a*'b -> bool) * 'b * 'a * 'b list -> 'b list *)

(* Let's try it out for ints
*)
subst(eq_int, 11, 15, 
  Cons(15,
    Cons(6,
      Cons(15,
        Cons(17,
          Cons(15,
            Cons(8,
              Empty)))))));         (* 11, 6, 11, 17, 11, 8 *)

(* Now the same with less_than
*)
fun less_than(x,y)
    = x < y;

subst(less_than, 11, 15, 
  Cons(15,
    Cons(6,
      Cons(15,
        Cons(17,
          Cons(15,
            Cons(8,
              Empty)))))));         (* 15, 6, 15, 11, 15, 8 *)

(* Now in_range
*)
fun in_range((small,large),x)
    = x>small andalso x<large;

in_range;                           (* (int*int)*int -> bool *)

(* Try it out with subst
*)
subst(in_range, 22, (11,16),
  Cons(15,
    Cons(6,
      Cons(15,
        Cons(17,
          Cons(15,
            Cons(8,
              Empty)))))));         (* 22, 6, 22, 17, 22, 8 *)

(* Substitution predicate.
*)
fun subst_pred(pred,n,Empty)
    = Empty
 |  subst_pred(pred,n,Cons(e,t))
    = if pred(e)
        then Cons(n, subst_pred(pred,n,t))
        else Cons(e, subst_pred(pred,n,t));

(* Its type
*)
subst_pred;                     (* ('a -> bool) * 'a * 'a list -> 'a list *)

(* Let's try it out.
*)
fun is_15(n)
    = eq_int(n,15);

subst_pred(is_15, 11, 
  Cons(15,
    Cons(6,
      Cons(15,
        Cons(17,
          Cons(15,
            Cons(8,
              Empty)))))));         (* 11, 6, 11, 17, 11, 8 *)

(* And now some currying.
*)
fun in_range_c(small,large)(x)
    = x>small andalso x<large;

(* What's the type?
*)
in_range_c;                         (* int*int -> int -> bool *)

(* Try it.
*)
fun in_range_c_11_16(x) =
    in_range_c(11,16)(x);

in_range_c_11_16(11);               (* false *)
in_range_c_11_16(16);               (* false *)
in_range_c_11_16(14);               (* true  *)
in_range_c_11_16(20);               (* false *)
in_range_c_11_16(5);                (* false *)

(* Let's use it together with subst_pred
*)
subst_pred(in_range_c(11,16), 22,
  Cons(15,
    Cons(6,
      Cons(15,
        Cons(17,
          Cons(15,
            Cons(8,
              Empty)))))));         (* 22, 6, 22, 17, 22, 8 *)

(* A new variant of subst_pred
*)
fun subst_c(pred)(n,Empty)
    = Empty
 |  subst_c(pred)(n,Cons(e,t))
    = if pred(e)
        then Cons(n, subst_c(pred)(n,t))
        else Cons(e, subst_c(pred)(n,t));

(* Its type.
*)
subst_c;                  (* ('a -> bool) -> 'a * ('a list) -> 'a list *)

(* Try it out.
*)
subst_c(in_range_c(11,16))(22,
  Cons(15,
    Cons(6,
      Cons(15,
        Cons(17,
          Cons(15,
            Cons(8,
              Empty)))))));         (* 22, 6, 22, 17, 22, 8 *)


(* Another way to write subst_c
*)
fun subst_c2(pred)
    = fn (n, Empty)
      => Empty
       | (n, Cons(e,t))
      => if pred(e)
           then Cons(n, subst_c2(pred)(n,t))
           else Cons(e, subst_c2(pred)(n,t));

(* Try it.
*)
subst_c2(in_range_c(11,16))(22,
  Cons(15,
    Cons(6,
      Cons(15,
        Cons(17,
          Cons(15,
            Cons(8,
              Empty)))))));         (* 22, 6, 22, 17, 22, 8 *)

(* Did you have tea?
*)
fun combine(Empty, Empty)
    = Empty
 |  combine(Empty, Cons(b,l2))
    = Cons(b, l2)
 |  combine(Cons(a,l1), Empty)
    = Cons(a, l1)
 |  combine(Cons(a,l1), Cons(b,l2))
    = Cons(a, combine(l1, Cons(b, l2)));

(* Simplify.
*)
fun combine2(Empty, l2)
    = l2
 |  combine2(Cons(a,l1),l2)
    = Cons(a, combine2(l1,l2));

(* What is it?
*)
combine;                            (* 'a list * 'a list -> 'a list *)
combine2;                           (* 'a list * 'a list -> 'a list *)

(* Try it.
*)
combine(
  Cons(1,
    Cons(2,
      Cons(3,
        Empty))),
  Cons(5,
    Cons(6,
      Cons(7,
        Cons(8,
          Cons(9,
            Empty))))));            (* 1 2 3 5 6 7 8 9 *)

combine2(
  Cons(1,
    Cons(2,
      Cons(3,
        Empty))),
  Cons(5,
    Cons(6,
      Cons(7,
        Cons(8,
          Cons(9,
            Empty))))));            (* 1 2 3 5 6 7 8 9 *)

(* Now the curried version
*)
fun combine_c(Empty)(l2)
    = l2
 |  combine_c(Cons(a,l1))(l2)
    = Cons(a,combine_c(l1)(l2));

(* Its type
*)
combine_c;                          (* 'a list -> 'a list -> 'a list *)

(* What's this
*)
combine_c(
  Cons(1,
    Cons(2,
      Cons(3,
        Empty))));                  (* 'a list -> 'a list *)

(* Write a function that does the same
*)
fun prefixer_123(l2)
    = Cons(1,
        Cons(2,
          Cons(3,
            l2)));

(* Try it.
*)
prefixer_123(
  Cons(5, Cons(6, Empty)));

(* Try the combine_c
*)
combine_c(
  Cons(1,
    Cons(2,
      Cons(3,
        Empty))))
  (Cons(5, Cons(6, Empty)));

(* Extensional and intensional combining.
*)
fun base(l2)
    = l2;

fun combine_s(Empty)
    = base
 |  combine_s(Cons(a, l1))
    = make_cons(a, combine_s(l1))
and
    make_cons(a,f)(l2)
    = Cons(a,f(l2));

(*****************************************************************************
*                                                                            *
* The eighth moral:                                                          *
*                                                                            *
* Replace stars by arrows to reduce the number of values consumed and to in- *
* crease the generality of the function defined.                             *
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

