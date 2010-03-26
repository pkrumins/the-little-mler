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


------------------------------------------------------------------------------

That's it. I hope you find these examples useful when reading "The Little
MLer" yourself! Go get it at http://bit.ly/8rlLXG, if you haven't already!


Sincerely,
Peteris Krumins
http://www.catonmat.net

