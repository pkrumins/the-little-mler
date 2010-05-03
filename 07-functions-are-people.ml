(*
** Chapter 7 of The Little MLer:
** Functions Are People, Too
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)

(* The identity function.
*)
fun identity(x)
    = x;                            (* 'a -> 'a *)

(* The true-maker function.
*)
fun true_maker(x)
    = true;                         (* 'a -> bool *)

(* Datatype that is Hot of bool or Cold of int.
*)
datatype bool_or_int =
    Hot  of bool
 |  Cold of int;

(* Members of bool_or_int
*)
Hot(true);
Cold(10);
Cold(5);

(* The hot-maker function.
*)
fun hot_maker(x)
    = Hot;                          (* 'a -> bool -> bool_or_int *)

(* What is just Hot?
*)
Hot;                                (* a function! bool -> bool_or_int *)

(* A new function.
*)
fun help(f)
    = Hot(true_maker(
            if true_maker(5)
              then f
              else true_maker));

(* What is the data type of help?
*)
help;                               (* ('a -> bool) -> bool_or_int *)

(* A chain datatype.
*)
datatype chain =
    Link of (int * (int -> chain));

(* What's strange about chain?
*)

(* It takes an int and a function that takes an int and returns a chain again *)

(* Let's write such function.
*)
fun ints(n)
    = Link(n+1, ints);              (* int -> chain *)

(* What is ints(0)?
*)
ints(0);                            (* it's Link(1, ints)! *)

(* What about ints(5)?
*)
ints(5);                            (* Link(6, ints) *)

(* Another function of type int -> chain
*)
fun skips(n)
    = Link(n+2, skips);

(* Let's try it.
*)
skips(8);                           (* Link(8, skips) *)

(* Some different functions now.
*)
fun divides_evenly(n,c)
    = (n mod c) = 0;                (* int*int -> bool *)

fun is_mod_5_or_7(n)
    = if divides_evenly(n, 5)
        then true
        else divides_evenly(n, 7);  (* int -> bool *)

(* Another function that produces a chain.
*)
fun some_ints(n)
    = if is_mod_5_or_7(n+1)
        then Link(n+1, some_ints)
        else some_ints(n+1);        (* int -> chain *)

(* Try it out.
*)
some_ints(1);                       (* Link(5, some_ints) *)
some_ints(17);                      (* Link(20, some_ints) *)
some_ints(116);                     (* Link(119, some_ints) *)

(* Let's find the n-th item in the chain.
*)
fun chain_item(n, Link(i, f))
    = if n = 1
        then i
        else chain_item(n-1, f(i)); (* (int*chain) -> int *)

(* Try it out.
*)
chain_item(1, some_ints(0));        (* 5 *)
chain_item(6, some_ints(0));        (* 20 *)
chain_item(37, some_ints(0));       (* 37 *)

(* Now it's time for prime numbers
*)
fun is_prime(n)
    = has_no_divisors(n, n-1)
and
    has_no_divisors(n, c)
    = if c = 1
        then true
        else
          if divides_evenly(n, c)
            then false
            else has_no_divisors(n, c-1);

(* What's the datatype of is_prime?
*)
is_prime;                           (* int -> bool *)

(* Test it.
*)
is_prime(2);                        (* true *)
is_prime(1000);                     (* false *)
is_prime(3);                        (* true *)
is_prime(37);                       (* true *)

(* Let's chain primes.
*)
fun primes(n)
    = if is_prime(n+1)
        then Link(n+1, primes)
        else primes(n+1);           (* int -> chain *)

(* Let's try it.
*)
chain_item(1, primes(1));           (* 2 *)
chain_item(2, primes(1));           (* 3 *)
chain_item(3, primes(1));           (* 5 *)
chain_item(12, primes(1));          (* 37 *)

(* Now something different.
*)
fun fibs(n)(m)
    = Link(n+m, fibs(m));

(* What is going on here?
*)
fibs;                               (* int -> int -> chain *)
fibs(1);                            (* int -> chain, with n = 1 *)
fibs(5)(1);                         (* Link(6, fibs(1)) *)

(* Currying!
*)
fun fibs_1(m)
    = Link(1+m, fibs(m));

fibs_1(1);                          (* Link(2, fibs(1)) *)
fibs_1(2);                          (* Link(3, fibs(2)) *)
fibs(2);                            (* int -> chain *)

(* Define fibs_2.
*)
fun fibs_2(m)
    = Link(2+m, fibs(m));

fibs_2(1);                          (* Link(3, fibs(1)) *)

(*****************************************************************************
*                                                                            *
* The seventh moral:                                                         *
*                                                                            *
* Some functions consume values of arrow type; some produce values of arrow  *
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

