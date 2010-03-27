(*
** Chapter 3 of The Little MLer:
** Cons Is Still Magnificent
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)

(* A new datatype - pizza
*)
datatype pizza =
        Crust
    |   Cheese of pizza
    |   Onion of pizza
    |   Anchovy of pizza
    |   Sausage of pizza;

(* Our favorite pizza
*)
Anchovy(Onion(Anchovy(Anchovy(Cheese(Crust)))));

(* Let's remove Anchovy to make it less salty
*)
fun remove_anchovy(Crust)
    = Crust
 |  remove_anchovy(Cheese(x))
    = Cheese(remove_anchovy(x))
 |  remove_anchovy(Onion(x))
    = Onion(remove_anchovy(x))
 |  remove_anchovy(Anchovy(x))
    = remove_anchovy(x)
 |  remove_anchovy(Sausage(x))
    = Sausage(remove_anchovy(x));

(* The datatype of remove_anchovy is remove_anchovy: pizza -> pizza
*)
remove_anchovy;

(* Example of remove_anchovy
*)
remove_anchovy(
  Anchovy(
    Onion(
      Anchovy(
        Anchovy(
          Cheese(
            Crust))))));              (* Onion(Cheese(Crust)) *)

(* Let's top Anchovy with Cheese
*)
fun top_anchovy_with_cheese(Crust)
    = Crust
 |  top_anchovy_with_cheese(Cheese(x))
    = Cheese(top_anchovy_with_cheese(x))
 |  top_anchovy_with_cheese(Onion(x))
    = Onion(top_anchovy_with_cheese(x))
 |  top_anchovy_with_cheese(Anchovy(x))
    = Cheese(Anchovy(top_anchovy_with_cheese(x)))
 |  top_anchovy_with_cheese(Sausage(x))
    = Sausage(top_anchovy_with_cheese(x));

(* The datatype of top_anchovy_with_cheese is pizza -> pizza
*)
top_anchovy_with_cheese;

(* Example of top_anchovy_with_cheese
*)
top_anchovy_with_cheese(
  Onion(
    Anchovy(
      Cheese(
        Cheese(
          Anchovy(
            Crust))))));
(* Onion(Cheese(Anchovy(Cheese(Cheese(Cheese(Anchovy(Crust))))))) *)

(* Combine remove_anchovy with top_anchovy_with_cheese
*)
top_anchovy_with_cheese(
  remove_anchovy(
    Onion(
      Anchovy(
        Cheese(
          Anchovy(
            Crust))))));         (* Onion(Cheese(Crust)) *)
remove_anchovy(
  top_anchovy_with_cheese(
    Onion(
      Anchovy(
        Cheese(
          Anchovy(
            Crust))))));         (* Onion(Cheese(Cheese(Cheese(Crust)))) *)

(* Substitute Achovy for Cheese
*)
fun subst_anchovy_by_cheese(x)
    = remove_anchovy(
        top_anchovy_with_cheese(x));

(* Datatype of subst_anchovy_by_cheese is pizza -> pizza
*)
subst_anchovy_by_cheese;

(* Example of subst_anchovy_by_cheese
*)
subst_anchovy_by_cheese(
  Onion(
    Anchovy(
      Cheese(
        Anchovy(
          Crust)))));           (* Onion(Cheese(Cheese(Cheese(Crust)))) *)

(* Another way to write subst_anchovy_by_cheese
*)
fun subst_anchovy_by_cheese2(Crust)
    = Crust
 |  subst_anchovy_by_cheese2(Cheese(x))
    = Cheese(subst_anchovy_by_cheese2(x))
 |  subst_anchovy_by_cheese2(Onion(x))
    = Onion(subst_anchovy_by_cheese2(x))
 |  subst_anchovy_by_cheese2(Anchovy(x))
    = Cheese(subst_anchovy_by_cheese2(x))
 |  subst_anchovy_by_cheese2(Sausage(x))
    = Sausage(subst_anchovy_by_cheese2(x));

(* Example of subst_anchovy_by_cheese2
*)
subst_anchovy_by_cheese2(
  Onion(
    Anchovy(
      Cheese(
        Anchovy(
          Crust)))));           (* Onion(Cheese(Cheese(Cheese(Crust)))) *)


(*****************************************************************************
*                                                                            *
* The third moral:                                                           *
*                                                                            *
* Functions that produce values of a datatype must use the associated        *
* constructors to build data of that type.                                   *
*                                                                            *
*****************************************************************************)


(*
** Go get yourself this wonderful book and have fun with ML language!
**
** Shortened URL to the book at Amazon.com: http://bit.ly/aNenRl
**
** Sincerely,
** Peteris Krumins
** http://www.catonmat.net
*)

