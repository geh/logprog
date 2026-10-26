# Practical Assignment 01

## 1. Encoding a Problem in Propositional Logic

To improve your computer's security, you must update some packages subject to the following conditions:

- Exactly one of packages `A`, `B`, or `C` must be installed.
- Package `E` must not be installed.
- Package `D` must be installed if package `B` is installed.
- If at least one of packages `A` or `C` is installed, then at least one of packages `B` or `E` must also be installed.
- Packages `D` and `E` must not both be installed.

1. Encode this problem as a formula `phi` such that the models of `phi` correspond to valid ways of updating the computer. You may use the logical connectives `->` and `<->`.
2. Convert this formula into an **equivalent CNF formula**.

## 2. The DPLL Algorithm and DIMACS-CNF Format

Useful material for exercises 2 and 3:

- [Conjunctive Normal Form (DIMACS Format) Explained](https://fairmut3x.wordpress.com/2011/07/29/cnf-conjunctive-normal-form-dimacs-format-explained/)
- [MiniSAT User Guide: How to Use the MiniSAT SAT Solver](https://www.dwheeler.com/essays/minisat-user-guide.html)
- [MiniSat (source code and binaries)](http://minisat.se/MiniSat.html)

1. Run the DPLL algorithm step by step on the following formulas from the first lecture:
   - The diplomatic formula.
   - The formula encoding the 3-node graph-coloring problem.
2. Convert both formulas above to CNF-DIMACS format and use `minisat` to verify that the first formula is `SAT` and the second is `UNSAT`.
3. For the diplomatic formula, how can you obtain an interpretation different from the one returned by the `minisat` solver?

## 3. The N-Queens Problem

Consider the *n*-queens problem (using chess queens).

Given `n >= 4`, place `n` queens on an `n x n` chessboard so that no queen attacks another. A queen attacks every square in its row, column, and either diagonal.

Write a program named `queens` that takes `n` as a command-line argument and prints a solution in the following format:

```text
$ queens 8
.......X
...X....
X.......
..X.....
.....X..
.X......
......X.
....X...
```

The program must internally generate a CNF formula encoding the problem, pass it to `minisat`, and then interpret the solver's output.

**Hint:** Given a set of variables `{x1, ..., xn}`, the condition that at most one of them may be true can be encoded by adding the clauses

```text
!xi | !xj
```

for every pair `1 <= i < j <= n`.

For what value of `n` does your program take more than 5 seconds to finish?
