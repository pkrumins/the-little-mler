(*
** Chapter 10 of The Little MLer:
** Building On Blocks
**
** Code examples assembled by Peteris Krumins (peter@catonmat.net).
** His blog is at http://www.catonmat.net  --  good coders code, great reuse.
**
** Get yourself this wonderful book at Amazon: http://bit.ly/aNenRl
*)

(* Peano Numbers
*)
fun eq_int(x,y)
    = x=y;                                  (* int*int -> bool *)

fun is_zero(n)
    = eq_int(n,0);                          (* int -> bool *)

fun succ(n)
    = n+1;                                  (* int -> int *)

exception Too_small;

fun pred(n)
    = if eq_int(n,0)
        then raise Too_small
        else n-1;                           (* int -> int *)

fun plus(n,m)
    = if is_zero(n)
        then m
        else succ(plus(pred(n),m));         (* int*int -> int *)

(* Try it out.
*)
plus(0,1);                                  (* 1 *)
plus(1,1);                                  (* 2 *)
plus(2,1);                                  (* 3 *)

(* Now the same using a datatype.
*)
datatype num =
    Zero
 |  One_more_than of num;

fun is_zero(Zero)
    = true
 |  is_zero(not_zero)
    = false;                                (* num -> bool *)

fun pred(Zero)
    = raise Too_small
 |  pred(One_more_than(n))
    = n;                                    (* num -> num *)

fun succ(n)
    = One_more_than(n);                     (* num -> num *)

fun plus(n,m)
    = if is_zero(n)
        then m
        else succ(plus(pred(n),m));         (* num -> num *)

(* Try it.
*)
plus(Zero, One_more_than(Zero));                   (* One_more_than(Zero) *)
plus(One_more_than(Zero), One_more_than(Zero));    (* One_more_than(One_more_than(Zero)) *)

(* Time for building blocks.
*)
signature N =
    sig
        type number
        exception Too_small
        val succ    : number -> number
        val pred    : number -> number
        val is_zero : number -> bool
    end;

(* Functors!
*)
functor NumberAsNum()
    :>
    N
    =
    struct
        datatype num =
            Zero
         |  One_more_than of num
        type number = num
        exception Too_small
        fun succ(n) =
            One_more_than(n)
        fun pred(Zero)
            = raise Too_small
         |  pred(One_more_than(n))
            = n
        fun is_zero(Zero)
            = true
         |  is_zero(foo)
            = false;
    end;

functor NumberAsInt()
    :>
    N
    =
    struct
        type number = int
        exception Too_small
        fun succ(n) = n + 1
        fun pred(n)
            = if n=0
                then raise Too_small
                else n-1
        fun is_zero(n)
            = n=0
    end;

(* Structures!
*)
structure IntStruct = NumberAsInt();
structure NumStruct = NumberAsNum();

(* Now the same for plus
*)
signature P =
    sig
        type number
        val plus : number*number -> number
    end;

functor PON(structure a_N : N)
    :>
    P
    =
    struct
        type number = a_N.number
        fun plus(n,m)
            = if a_N.is_zero(n)
                then m
                else a_N.succ(plus(a_N.pred(n),m))
    end;

structure IntArith = PON(structure a_N = IntStruct);
structure NumArith = PON(structure a_N = NumStruct);

(* Now let's try it out!
*)
(*
IntArith.plus(1,2);                         (* 3 *)
NumArith.plus(Zero, One_more_than(Zero));   (* One_more_than(Zero) *)
*)

(* Doesn't work because plus operates on numbers and not ints or nums! *)

(* Let's make it work.
*)
signature N_C_R = (* numbers with conceal reveal *)
    sig
        type number
        exception Too_small
        val conceal : int -> number
        val succ    : number -> number
        val pred    : number -> number
        val is_zero : number -> bool
        val reveal  : number -> int
    end;

functor NumberAsInt()
    :>
    N_C_R
    =
    struct
        type number = int
        exception Too_small
        fun conceal(n) = n
        fun succ(n) = n + 1
        fun pred(n)
            = if n=0
                then raise Too_small
                else n-1
        fun is_zero(n)
            = n=0
        fun reveal(n) = n
    end;

functor NumberAsNum()
    :>
    N_C_R
    =
    struct
        datatype num =
            Zero
         |  One_more_than of num
        type number = num
        exception Too_small
        fun conceal(n)
            = if n=0
                then Zero
                else One_more_than(conceal(n-1))
        fun succ(n) =
            One_more_than(n)
        fun pred(Zero)
            = raise Too_small
         |  pred(One_more_than(n))
            = n
        fun is_zero(Zero)
            = true
         |  is_zero(foo)
            = false;
        fun reveal(n)
            = if is_zero(n)
                then 0
                else 1 + reveal(pred(n))
    end;

(* Rebuild the structures.
*)
structure IntStruct = NumberAsInt();
structure IntArith = PON(structure a_N = IntStruct);

structure NumStruct = NumberAsNum();
structure NumArith = PON(structure a_N = NumStruct);

(* Try it.
*)
NumStruct.reveal(
  NumStruct.succ(
    NumStruct.conceal(0)));                 (* 1 *)

(* Doesn't work
NumStruct.reveal(
  NumArith.plus(
    NumStruct.conceal(1),
    NumStruct.conceal(2)));                 (* 3 *)
*)

(* We need to say that PON produces structures whose type number is the same
** as the type number in a_N, the functor's dependency.
*)
functor PON(structure a_N : N)
    :>
    P where type number = a_N.number
    =
    struct
        type number = a_N.number
        fun plus(n,m)
            = if a_N.is_zero(n)
                then m
                else a_N.succ(plus(a_N.pred(n),m))
    end;

(* Now let's create plus over nums
*)
structure NumArith = PON(structure a_N = NumStruct);
structure IntArith = PON(structure a_N = IntStruct);

(* Try it.
*)
NumStruct.reveal(
  NumArith.plus(
    NumStruct.conceal(1),
    NumStruct.conceal(2)));                 (* 3 *)

IntStruct.reveal(
  IntArith.plus(
    IntStruct.conceal(1),
    IntStruct.conceal(2)));                 (* 3 *)

(* The 2nd way out
*)
functor NumberAsInt2()
    :>
    N where type number = int
    =
    struct
        type number = int
        exception Too_small
        fun succ(n) = n + 1
        fun pred(n)
            = if n=0
                then raise Too_small
                else n-1
        fun is_zero(n)
            = n=0
    end;

structure IntStruct2 = NumberAsInt2();
structure IntArith2  = PON(structure a_N = IntStruct2);

(* It should work.
*)
IntArith2.plus(1,2);                    (* 3, and it does! *)

(* Can we do the same for NumberasNum2?
*)

(* We can't 
functor NumberAsNum()
    :>
    N where type number = num
    =
    struct
        datatype num =
            Zero
         |  One_more_than of num
        type number = num
        exception Too_small
        fun succ(n) =
            One_more_than(n)
        fun pred(Zero)
            = raise Too_small
         |  pred(One_more_than(n))
            = n
        fun is_zero(Zero)
            = true
         |  is_zero(foo)
            = false;
    end;
*)

(* because in `where type number = num` num is not visible *)

(* similarity
*)
signature S =
    sig
        type number1
        type number2
        val similar : number1*number2 -> bool
    end;

functor Same(structure a_N : N
             structure b_N : N)
    :>
    S where type number1 = a_N.number
      where type number2 = b_N.number
    =
    struct
        type number1 = a_N.number
        type number2 = b_N.number
        fun sim(n,m)
            = if a_N.is_zero(n)
                then b_N.is_zero(m)
                else
                    sim(a_N.pred(n), b_N.pred(m))
        fun similar(n,m)
            = ((sim(n,m)
                handle
                    a_N.Too_small => false)
                handle
                    b_N.Too_small => false)
    end;

structure SimIntNum = Same(structure a_N = IntStruct
                           structure b_N = NumStruct);
structure SimNumInt = Same(structure a_N = NumStruct
                           structure b_N = IntStruct);

SimNumInt.similar(
  NumStruct.conceal(0),
  IntStruct.conceal(0));                    (* true *)

(* Time for a snack.
*)
fun new_plus(x,y)
    = NumStruct.reveal(
        NumArith.plus(
          NumStruct.conceal(x),
          NumStruct.conceal(y)));

signature J =
    sig
        val new_plus : int*int -> int
    end;

functor NP(structure a_N : N_C_R
           structure a_P : P
           sharing type
             a_N.number
             =
             a_P.number)
    :>
    J
    =
    struct
        fun new_plus(x,y)
            = a_N.reveal(
                a_P.plus(
                  a_N.conceal(x),
                  a_N.conceal(y)))
    end;

structure NPStruct = NP(structure a_N = NumStruct
                        structure a_P = NumArith);

(* Another way to say the same
*)
structure NPStruct = NP(structure a_N = NumberAsNum()
                        structure a_P = PON(structure a_N = a_N));

(* TON
*)
signature T =
    sig
        type number
        val times : number*number -> number
    end;

functor TON(structure a_N : N
            structure a_P : P
            sharing type
              a_N.number
              =
              a_P.number)
    :>
    T where type number = a_N.number
    =
    struct
        type number = a_N.number
        fun times(n,m)
            = if a_N.is_zero(m)
                then m
                else a_P.plus(n, times(n,a_N.pred(m)))
    end;

structure TONStruct = TON(structure a_N = NumberAsNum()
                          structure a_P = PON(structure a_N = a_N));

(* type mismatch, not sure why.
NumStruct.reveal(
  TONStruct.times(
    NumStruct.conceal(5),
    NumStruct.conceal(5)));     (* 25 *)
*)

structure TONStruct = TON(structure a_N = NumStruct
                          structure a_P = NumArith);

NumStruct.reveal(
  TONStruct.times(
    NumStruct.conceal(5),
    NumStruct.conceal(5)));     (* 25 *)

(*****************************************************************************
*                                                                            *
* The tenth moral:                                                           *
*                                                                            *
* Real programs consist of many components. Specify the dependencies among   *
* these components using signatures and functors.                            *
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

