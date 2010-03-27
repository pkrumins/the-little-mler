This repository contains all the code examples from the book "The Little
MLer." The Little MLer book has two goals. The first and primary goal is to
teach you to think recursively about types and programs. The second goal is to
expose you to two important topics concerning large programs: dealing with
exceptional situations and composing program components.

If you're interested, get the book from Amazon: http://bit.ly/8rlLXG

The code examples were copied (and completed where necessary) from
"The Little MLer" by Peteris Krumins (peter@catonmat.net).

His blog is at http://www.catonmat.net  --  good coders code, great reuse.

------------------------------------------------------------------------------

Table of contents:
    [01] Chapter  1: Building Blocks
         01-building-blocks.ml
    [02] Chapter  2: Matchmaker, Matchmaker
         02-matchmaker.ml
    [03] Chapter  3: Cons Is Still Magnificent
         03-cons-magnificent.ml
    [04] Chapter  4: Look to the Stars
         04-stars.ml
    [05] Chapter  5: Couples Are Magnificent, Too
         05-couples.ml

    ...
    work in progress, adding new chapters every once in a while


[01]-Chapter-1-Building-Blocks------------------------------------------------

See 01-building-blocks.ml file for code examples.

Chapter 1 introduces data types. For example, the type of integer 5 is int and
the type of real number 5.32 is real. You can also define your own data types.
For example,

    datatype seasoning =
            Salt
        |   Pepper;

introduces a new data type 'seasoning'. Salt and Pepper now both are of type
seasoning.

Data types can also be recursive, for example,

    datatype num =
            Zero
        |   One_more_than of num;

creates a type num, that is either Zero, or One_more_than of itself. For
example, One_more_than(Zero) is a num. So is One_more_than(One_more_than(Zero)).

Next, parametrized types are introduced. Here is an example,

    datatype 'a open_faced_sandwich =
            Bread of 'a
        |   Slice of 'a open_faced_sandwich;

The elements of this datatype are Bread(0), Bread(true), Slice(Bread(0)). In
these examples, 'a get associated with types int, bool and open_faced_sandwich.

Finally the chapter presents the first moral:

.----------------------------------------------------------------------------.
|                                                                            |
| The first moral:                                                           |
|                                                                            |
| Use datatype to describe types. When a type contains lots of values, the   |
| datatype definition refers to itself. Use 'a with datatype to define       |
| shapes.                                                                    |
|                                                                            |
'----------------------------------------------------------------------------'


[02]-Chapter-2-Matchmaker-----------------------------------------------------

See 02-matchmaker.ml file for code examples.

Chapter 2 introduces functions, pattern matching on function arguments and
recursion. It takes you very carefully through several examples so you
understood the topic precisely.

For example, given this datatype,

    datatype 'a shish =
            Bottom of 'a
        |   Onion of 'a shish
        |   Lamb of 'a shish
        |   Tomato of 'a shish;

then the following function determines the type of Bottom,

    fun what_bottom(Bottom(x))
        = x
     |  what_bottom(Onion(x))
        = what_bottom(x)
     |  what_bottom(Lamb(x))
        = what_bottom(x)
     |  what_bottom(Tomato(x))
        = what_bottom(x);

The data type of this function is 'a shish -> 'a, that is, it takes a
parametrizable type 'a shish and returns the parametrization 'a.

Here is an example of applying this function.

    what_bottom(Onion(Lamb(Tomato(Bottom(55)))));

It produces value 55 because it matches the Onion(x) rule, where x is
Lamb(Tomato(Bottom(55))), and recurses with the argument x on itself. Next
it matches Lamb(x), with x being Tomato(Bottom(55)) and recurses. Then it
matches Tomato(Bottom(x)), setting x to Bottom(55) and recurses. Finally the
first rule Bottom(x) matches, with x being 55. This rule is the result of the
function, therefore the result is 55.

The chapter ends with the second moral:

.----------------------------------------------------------------------------.
|                                                                            |
| The second moral:                                                          |
|                                                                            |
| The number and order of the patterns in the definition of a function shold |
| match that of the definition of the consumed datatype.                     |
|                                                                            |
'----------------------------------------------------------------------------'

[03]-Chapter-3-Cons-Is-Still-Magnificent--------------------------------------

See 03-cons-magnificent.ml file for code examples.

Chapter 3 continues the adventure of manipulating datatypes. The examples in
this chapter show how to remove a level of datatype, how to add a level of
datatype and how to modify a level. The mindset you develop with these
examples is the same as in Lisp, where you manipulate lists by taking car and
cdr, dropping car, replacing car and consing the result together. That's why
the title involves the word "cons".

The first example in this chapter shows how to remove a level of nested type
and how to add a level of datatype (don't know how to express myself correctly
on what the example does.)

Here is an example, suppose you have this datatype,

    datatype pizza =
            Crust
        |   Cheese of pizza
        |   Onion of pizza
        |   Anchovy of pizza
        |   Sausage of pizza;

And you have constructed an item of this type,

    Anchovy(
      Onion(
        Anchovy(
          Anchovy(
            Cheese(
              Crust)))));

And you wish to remove all occurances of Anchovy from the type. Then the
following function does it,

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

The base case here is Crust, and then it uses pattern matching on types
Cheese(x), Onion(x), Anchovy(x), Sausage(x). If the type is Anchovy(x), then
the Anchovy is removed by recusing on matched pattern x and dropping Anchovy.

Similarly, functions to add a layer and replace a layer are written.

At the end of the chapter, as usual, the third moral is presented.

.----------------------------------------------------------------------------.
|                                                                            |
| The third moral:                                                           |
|                                                                            |
| Functions that produce values of a datatype must use the associated        |
| constructors to build data of that type.                                   |
|                                                                            |
'----------------------------------------------------------------------------'


[04]-Chapter-4-Look-to-the-Stars----------------------------------------------

See 04-stars.ml file for code examples.

Chapter 4 introduces stars and functions on stars. Stars combine datatypes.
For example, consider these two datatypes,

    datatype meza = 
            Shrimp
        |   Calamari
        |   Escargots
        |   Hummus;

    datatype main =
            Steak
        |   Ravioli
        |   Chicken
        |   Eggplant;

If we write that something is of type (meza*main), then we mean all items
from the set of all possible combinations of meza and main:

    (Shrimp,Steak)
    (Shrimp,Ravioli)
    (Shrimp,Chicken)
    (Shrimp,Eggplant)
    (Calamari,Steak)
    (Calamari,Ravioli)
    (Calamari,Chicken)
    (Calamari,Eggplant)
    (Escargots,Steak)
    (Escargots,Ravioli)
    (Escargots,Chicken)
    (Escargots,Eggplant)
    (Hummus,Steak)
    (Hummus,Ravioli)
    (Hummus,Chicken)
    (Hummus,Eggplant)

We can then introduce functions that consume (and produce) stars. For example,

    fun has_steak(a:meza,Steak,d:dessert):bool
        = true
     |  has_steak(a:meza,ns,d:dessert):bool
        = false;

The has_steak function takes a (meza*main*dessert) and produces a bool,
depending on main. If main is Steak, then it's true, otherwise it's false.

The chapter also shows how to do pattern matching more effectively and how to
force types for function arguments (like in the example above).

The fourth moral follows:

.----------------------------------------------------------------------------.
|                                                                            |
| The fourth moral:                                                          |
|                                                                            |
| Some functions consume values of star type; some produce values of star    |
| type.                                                                      |
|                                                                            |
'----------------------------------------------------------------------------'

[05]-Chapter-5-Couples-Are-Magnificent-Too------------------------------------

See 05-couples.ml file for code examples.

Chapter 5 shows how to create data types with stars. Here is an example,

    datatype 'a pizza =
            Bottom
        |   Topping of ('a * ('a pizza));

The members of this 'a pizza are all possible parametrizations of 'a pizza.
For example, int pizza, bool pizza, dessert pizza, etc. More concrete
example is Topping(true, Topping(true, Bottom)), which is of type bool pizza.

Then the chapter shows how to work on datatypes like these, and how to do
efficient pattern matching, and how to shorten the written functions by
thinking how the patterns matched.

For example, this long function,

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

Can be rewritten as:

    fun rem_fish2(x, Bottom)
        = Bottom
     |  rem_fish2(x, Topping(t, p))
        = if eq_fish(x, t)
            then rem_fish2(x, p)
            else Topping(t,rem_fish2(x,p));

With the help of helper function eq_fish.

The fifth moral follows:

.----------------------------------------------------------------------------.
|                                                                            |
| The fifth moral:                                                           |
|                                                                            |
| Write the first draft of a function following all the morals. When it is   |
| correct and no sooner, simplify.                                           |
|                                                                            |
'----------------------------------------------------------------------------'


------------------------------------------------------------------------------

That's it. I hope you find these examples useful when reading "The Little
MLer" yourself! Go get it at http://bit.ly/8rlLXG, if you haven't already!


Sincerely,
Peteris Krumins
http://www.catonmat.net

