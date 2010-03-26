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

------------------------------------------------------------------------------

That's it. I hope you find these examples useful when reading "The Little
MLer" yourself! Go get it at http://bit.ly/8rlLXG, if you haven't already!


Sincerely,
Peteris Krumins
http://www.catonmat.net

