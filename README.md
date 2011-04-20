Simplex
=======
A simple library that helps you understand Linear Programming tableaus and Simplex/Dual Simplex pivots.

Also implements a simple Fraction class.

Examples
========
Refer to the "examples" folder

Sample Output
=============

    Simplex Pivot on row 2, column 1
    0	-5/9	0	8/9	| 40
    ---
    0	4/9	1	-1/9	| 1
    1	5/9	0	1/9	| 5

    Simplex Pivot on row 1, column 2
    0	0	5/4	3/4	| 165/4
    ---
    0	1	9/4	-1/4	| 9/4
    1	0	-5/4	1/4	| 15/4

    Tableau is optimal!

TODO
====
* The Fraction class deals mainly with integers, not floats
* Have Fraction.convert() convert floats into fractions