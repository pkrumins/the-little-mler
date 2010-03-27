(*
** Chapter 4 of The Little MLer:
** Look to the Stars
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)

(* Meza
*)
datatype meza = 
        Shrimp
    |   Calamari
    |   Escargots
    |   Hummus;

(* Main
*)
datatype main =
        Steak
    |   Ravioli
    |   Chicken
    |   Eggplant;

(* Salad
*)
datatype salad =
        Green
    |   Cucumber
    |   Greek;

(* Dessert
*)
datatype dessert =
        Sundae
    |   Mousse
    |   Torte;

(* Let's construct a meal!
*)
(Calamari, Ravioli, Greek, Sundae);

(* The type of the meal is (meza * main * salad * dessert)
*)
(Calamari, Ravioli, Greek, Sundae);

(* Our favorite meal with just two ingredients
*)
(Shrimp, Sundae);

(* Let's add Steak to our meza
*)
fun add_a_steak(Shrimp)
    = (Shrimp, Steak)
 |  add_a_steak(Calamari)
    = (Calamari, Steak)
 |  add_a_steak(Escargots)
    = (Escargots, Steak)
 |  add_a_steak(Hummus)
    = (Hummus, Steak);

(* What's the type of add_a_steak?
*)
add_a_steak;                    (* It's meza -> (meza * main) *)

(* Example of add_a_steak
*)
add_a_steak(Shrimp);            (* (Shrimp, Steak) *)

(* We can write it shorter
*)
fun add_a_steak2(x)
    = (x, Steak);

(* Examples of add_a_steak2
*)
add_a_steak2(Shrimp);           (* (Shrimp, Steak) *)
add_a_steak2(5);                (* (5, Steak) *)

(* What's the type of add_a_steak2?
*)
add_a_steak2;                   (* It's 'a -> ('a * main) *)

(* eq_main determines if the two foods both are mains
*)
fun eq_main(Steak, Steak)
    = true
 |  eq_main(Ravioli, Ravioli)
    = true
 |  eq_main(Chicken, Chicken)
    = true
 |  eq_main(Eggplant, Eggplant)
    = true
 |  eq_main(a_main, another_main)
    = false;

(* The type of eq_main is (main*main) -> bool
*)
eq_main;

(* Examples of eq_main
*)
eq_main(Steak, Steak);          (* true *)
eq_main(Steak, Eggplant);       (* false *)

(* has_steak determines if Steak is for main in (meza,main,dessert) 
*)
fun has_steak(a_meza,Steak,a_dessert)
    = true
 |  has_steak(a_meza,a_main,a_dessert)
    = false;

(* What's the type of has_steak?
*)
has_steak;                      (* ('a,main,'b) -> bool *)

(* Examples of has_steak
*)
has_steak(Shrimp, Steak, Torte);    (* true *)
has_steak(5, Steak, true);          (* true *)
has_steak(5, Chicken, true);        (* false *)

(* Let's restrict the types for has_steak
*)
fun has_steak2(a:meza,Steak,d:dessert):bool
    = true
 |  has_steak2(a:meza,ns,d:dessert):bool
    = false;

(* What's the type of has_steak2 now?
*)
has_steak2;                     (* (meza,main,dessert) -> bool *)

(* Let's also restrict the types for add_a_steak
*)
fun add_a_steak3(x:meza):(meza*main)
    = (x, Steak);

(*****************************************************************************
*                                                                            *
* The fourth moral:                                                          *
*                                                                            *
* Some functions consume values of star type; some produce values of star    *
* type.                                                                      *
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

