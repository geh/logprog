# Logic Programming Make-up Exam

* This exam is to be completed on paper.

## 1. Propositional Logic

### 1.1 Problem Representation 1

Which of the following formulas represents the proposition:

“They will arrive on the 8:15 train or the 9:15 train; if they arrive on the first one, they will have time to visit us”?

Let:

- `p` mean “They will arrive on the 8:15 train.”
- `q` mean “They will arrive on the 9:15 train.”
- `r` mean “They will have time to visit us.”

1. $\neg p \rightarrow q \vee r$
2. $p \vee q \rightarrow r$
3. $(p \rightarrow q) \wedge (p \wedge r)$
4. $p \vee \neg q \rightarrow r$
5. $(p \vee q) \wedge (p \rightarrow r)$

### 1.2 Problem Representation 2

Which of the following propositions have the form $(p \wedge q) \rightarrow r$?

1. If you do not go to the party, Chari, who is already ready, will get angry with you.
2. Haendel is a great composer, and so is Vivaldi.
3. If inflation rises and an election is approaching, then pensions increase.
4. They will arrive on the 8:15 train or the 9:15 train; if they arrive on the first one, they will have time to visit us.

### 1.3 Conjunctive Normal Form (CNF)

Convert the following formulas into equivalent CNF formulas:

1. $(A \vee (B \rightarrow C)) \rightarrow D$
2. $A \vee (B \wedge C) \vee D$
3. $Z \leftrightarrow X$

### 1.4 DIMACS

Convert each of the following formulas into a file in DIMACS CNF format. You do not need to include the line beginning with `p`.

1. $(\neg a \vee \neg b) \wedge \neg a \wedge (b \vee c)$
2. $(a \vee \neg b \vee d) \wedge \neg b \wedge (c \vee \neg d) \wedge (a \vee c)$

### 1.5 Problem Encoding

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

Express each answer by beginning with “for every index ... between ... and ...” wherever needed. For example: “for every index $i$ between 1 and 4, for every index $j$ between 1 and 4, ...”.

## 2. Satisfiability Modulo Theories (SMT)

### 2.1 SEND+MORE=MONEY

In this famous puzzle, the goal is to determine the value of each letter:

```text
SEND + MORE = MONEY
```

Take the following into account:

- Each letter has a value between 0 and 9, except for `S` and `M`, whose values are between 1 and 9.
- Each letter represents a different digit (use the `distinct` function).
- (Reminder) The value of a number written as `XYZ` is $Z + 10Y + 100X$.

Encode this puzzle as an SMT-LIB formula using integer variables.

The syntax does not need to match SMT-LIB exactly; it must be clear which variables you use and which constraints represent the problem.

### 2.2 Making Change with SMT

The cash register contains coins worth 5, 10, 25, and 50 cents, as well as 1- and 2-peso coins.

Write an SMT formula that is satisfiable if and only if it is possible to give 2.30 pesos in change using at most 4 coins.

### 2.3 Uninterpreted Functions

Let `f`, `g`, and `h` be functions, and let `x` and `z` be integer constants.

Write a formula specifying that:

- `f(f(x))` is different from `g(x)`.
- `f(x)` is different from `g(x)`, or `f(y)` is different from `g(g(y))`.
- `x` is equal to `z` or to `f(z)`.

### 2.4 Tollbooths (Turnpike Problem)

The turnpike problem is as follows:

“Given $n(n-1)/2$ distances between pairs of points, is there a configuration of $n$ points on a line that has exactly those pairwise distances?”

- Define a language corresponding to this problem.
- Show that this language belongs to **NP**.

Suppose there is a straight highway with $n$ tollbooths whose positions along the highway are known. Finding the distances between every pair of tollbooths is easy: simply subtract their positions.

Now consider the inverse problem. We know there are $n$ tollbooths and have $n(n-1)/2$ pairwise distances, but we do not know which pair of tollbooths corresponds to each distance.

Let $D=\{1,2,2,2,3,3,3,4,5,5,5,6,7,8,10\}$.

Encode an SMT formula that is satisfiable if and only if the list $D$ (which contains 15 elements) corresponds to the positions of 6 tollbooths.

What are the positions of those tollbooths, assuming the first one is at kilometer 0?
