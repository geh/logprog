# Logic Programming Exam

* This exam is to be completed on a computer.

## 1. Propositional Logic

### 1.1 Conjunctive Normal Form (CNF)

Convert the following formulas into equivalent CNF formulas:

1. $(A \vee (B \rightarrow C)) \rightarrow D$
2. $A \vee (B \wedge C) \vee D$
3. $Z \leftrightarrow X$

### 1.2 DIMACS

Convert each of the following formulas into a file in DIMACS CNF format. You do not need to include the line beginning with `p`.

1. $(\neg a \vee \neg b) \wedge \neg a \wedge (b \vee c)$
2. $(a \vee \neg b \vee d) \wedge \neg b \wedge (c \vee \neg d) \wedge (a \vee c)$

### 1.3 Problem Encoding

Consider a $4 \times 4$ version of Sudoku, in which the board has 4 columns and 4 rows and is divided into 4 subgrids. Each cell contains a number between 1 and 4.

```text
43|12
12|34
--+--
34|21
21|43
```

We want to encode this $4 \times 4$ Sudoku as a propositional logic formula that is satisfiable if and only if the puzzle has a solution. Moreover, a satisfying interpretation of the formula will tell us how to fill in the board correctly.

We use propositional symbols as follows. For each $i$, $j$, and $k$ between 1 and 4, we have a propositional symbol $p_{ijk}$.

The idea is that $p_{ijk}$ is true in an interpretation if and only if the cell at position $(i,j)$ contains digit $k$.

- Which clauses specify that every cell has at least one value between 1 and 4?
- Which clauses specify that every cell has exactly one value between 1 and 4?
- Which clauses specify that all cells in the upper-left subgrid have distinct values?
- Which clauses specify that all cells in the first column have distinct values?
- Which clauses specify that all cells in the first row have distinct values?

## 2. Satisfiability Modulo Theories (SMT)

### 2.1 SEND+MORE=MONEY

In this famous puzzle, the goal is to determine the value of each letter:

```text
SEND + MORE = MONEY
```

Take the following into account:

- Each letter has a value between 0 and 9, except for `S` and `M`, whose values are between 1 and 9.
- Each letter represents a different digit (use the `distinct` function).
- (Hint/reminder) The value of a number written as `XYZ` is $Z + 10Y + 100X$.

Encode this puzzle as an SMT-LIB formula.

### 2.2 A Particular List

Write an SMT-LIB formula to find a list satisfying the following constraints:

- It has 9 integer elements $h_0, h_1, \ldots, h_8$.
- Every element is strictly greater than 0.
- The sum of all elements is less than or equal to 50.
- All elements are distinct (use the `distinct` function).
- The sum of the elements at positions divisible by 2 equals the sum of all the other elements.
- The sums of the elements in the three sublists—positions 0 to 2, 3 to 5, and 6 to 8—are equal.

### 2.3 Average of Two Integers

Prove the following for 16-bit integers (represented by bit-vectors).

Given two integer values $x$ and $y$, their average (rounded down to the lower integer) is usually computed using the formula $(x+y)/2$.
Unfortunately, this can produce incorrect results due to overflow (the value $x+y$ cannot be represented).

A clever alternative is to use `(x & y) + ((x^y)>>1)`, where `&` is bitwise AND and `^` is bitwise XOR. The advantage is that overflow cannot occur.

Use an SMT-LIB formula to prove that the two formulas are equivalent for every pair of integers $x$ and $y$ that are strictly less than 32768.

### 2.4 Bit-Vectors

We work with 16-bit bit-vectors.

Encode the following in an SMT-LIB formula. Show that there exist two bit-vectors `x` and `z` such that:

- `x + z` equals the bit-vector representing the integer 33.
- `x XOR y` equals the bit-vector representing the integer 100.
