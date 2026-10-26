# Z3 and SMT: Introduction and Lab Exercises

## 1. Z3: An SMT Solver

Z3 is an SMT solver developed by Microsoft Research. It checks the satisfiability of logical formulas over one or more theories and is often used as a component in software verification and other tools that solve logical constraints.

Z3 supports input formats including SMT-LIB and DIMACS-CNF. On Debian or Ubuntu, it can be installed with:

```bash
sudo apt install z3
```

Z3 is distributed as a single executable that includes a SAT solver and solvers for several theories.

## 2. Writing Z3 Scripts

Z3 scripts use an extension of the SMT-LIB 2.0 format. A script is a sequence of commands, and Z3 maintains a stack of declarations and assertions.

- `declare-const` declares a constant of a given sort.
- `declare-fun` declares a function.
- `assert` adds a formula to Z3's current context.
- `check-sat` checks whether the current set of formulas is satisfiable.
- `get-model` returns an interpretation satisfying the assertions, when one exists.
- `push` creates a new scope.
- `pop` removes declarations and assertions added since the corresponding `push`.

A call to `check-sat` returns `sat` if the assertions are satisfiable, `unsat` if they are inconsistent, or `unknown` if Z3 cannot determine satisfiability.

## 3. Exercise: Propositional Logic

Use Z3 to check propositional equivalences. For example, the following script checks De Morgan's law:

```lisp
(declare-fun x () Bool)
(declare-fun y () Bool)
(assert (= (not (and x y))
           (or (not x) (not y))))
(check-sat)
```

Determine whether the following equivalences hold by encoding them in Z3:

1. `not (x or y)` is equivalent to `(not x) and (not y)`.
2. `(x and y)` is equivalent to `not ((not x) or (not y))`.

You can also name formulas using `define-fun`. For example:

```lisp
(declare-const a Bool)
(declare-const b Bool)
(define-fun demorgan () Bool
  (= (and a b) (not (or (not a) (not b)))))
(assert (not demorgan))
(check-sat)
```

## 4. Exercise: Arithmetic and Equation Solving

### 4.1 Integer arithmetic

In this script, `a` must be greater than 10, and the function `f`, applied to `a` and `true`, must return an integer less than 100:

```lisp
(declare-const a Int)
(declare-fun f (Int Bool) Int)
(assert (> a 10))
(assert (< (f a true) 100))
(check-sat)
(get-model)
```

Run the script and explain the model returned by Z3.

### 4.2 Solving equations

Use Z3 to solve the following system:

```lisp
(declare-const x Int)
(declare-const y Int)
(assert (= (+ x y) 10))
(assert (= (+ x (* 2 y)) 20))
(check-sat)
(get-model)
```

1. Explain the output.
2. Solve the system `3x + 2y = 36`, `5x + 4y = 64` using Z3.

### 4.3 Using Z3 as a calculator

Z3 supports integer division, modulo, remainder, and real arithmetic. Extend the following example to calculate the requested values:

```lisp
(declare-const a Int)
(declare-const r1 Int)
(declare-const r2 Int)
(declare-const r3 Int)
(assert (= a 10))
(assert (= r1 (div a 4))) ; integer division
(assert (= r2 (mod a 4))) ; modulo
(assert (= r3 (rem a 4))) ; remainder
(check-sat)
(get-model)
```

Use Z3 to calculate and store the results in constants:

1. `16 mod 2`
2. `16` divided by `4`
3. The remainder of integer division of `16` by `5`

### 4.4 Using the assertion stack

Z3 maintains a global stack of declarations and assertions. `push` saves the current scope, and `pop` removes the assertions and declarations added since the corresponding `push`.

```lisp
(declare-const x Int)
(declare-const y Int)
(declare-const z Int)
(push)
(assert (= (+ x y) 10))
(assert (= (+ x (* 2 y)) 20))
(check-sat)
(get-model)
(pop)
(push)
(assert (= (+ (* 3 x) y) 10))
(assert (= (+ (* 2 x) (* 2 y)) 21))
(check-sat)
(get-model)
```

Explain the output. In particular, compare the results before and after `pop`.

## 5. Exercise: Menu Combinations

Encode the following menu choices in Z3 and determine which combination of items costs exactly $15.05:

- Fruit salad: $2.15
- French fries: $2.75
- Vegetable salad: $3.35
- Chicken wings: $3.55
- Mozzarella sticks: $4.20
- Tasting platter: $5.80

Does the problem have other solutions? How could you find them?

## 6. Exercise: Improved N-Queens Encodings

The classic n-queens puzzle asks you to place `n` queens on an `n x n` chessboard so that no queen attacks another.

Use one `n`-bit vector for each row. Each row must contain at most one set bit. One compact way to express this constraint is:

```text
(r & (r - 1)) == 0
```

where `r` is the bit-vector for a row. This expression is zero exactly when `r` has at most one bit set.

Complete the encoding:

1. Ensure that each column contains exactly one queen, using as few constraints as possible.
2. Ensure that each diagonal contains at most one queen.
3. Write a program that accepts `n` and generates an SMT-LIB encoding of the n-queens problem.
4. Write a program that uses the Z3 API to enumerate solutions.
5. Add symmetry-breaking constraints to avoid enumerating solutions that are rotations or reflections of previously found solutions.

## 7. Exercise: Sudoku

A Sudoku puzzle fills a `9 x 9` grid with digits 1 through 9. Each digit must occur exactly once in every row, every column, and every `3 x 3` subgrid.

Use the following puzzle as input:

```text
..1.2....
..9.63...
3....814.
.9....83.
..4.7.6..
.37....2.
.159....2
...48.5..
....1.3..
```

Write a program that:

1. Encodes Sudoku as an SMT formula using bit-vectors.
2. Encodes Sudoku as an SMT formula using integers.
3. Calls the Z3 API to enumerate solutions.

Test your program on the puzzle above or another Sudoku puzzle.

## 8. Exercise: Project Euler and Declarative Optimization

This exercise illustrates a declarative, "test-only" approach: specify the mathematical constraints of a problem and let Z3 find a solution, rather than implementing a search algorithm directly.

Find the largest palindrome that is the product of two three-digit integers.

1. Declare integer constants for `product`, `factor1`, and `factor2`.
2. Constrain `factor1` and `factor2` to be between 100 and 999.
3. Assert that `product = factor1 * factor2`.
4. Express the six-digit palindrome as `abccba`, using digit variables `a`, `b`, and `c`:
   `product = 100000*a + 10000*b + 1000*c + 100*c + 10*b + a`.
5. Constrain `a` to be between 1 and 9, and `b` and `c` to be between 0 and 9.
6. Use `check-sat` and `get-model` to obtain a solution.
7. Use `maximize product` to search for the largest palindrome. If optimization is slow, consider whether adding a useful constraint on the leading digit `a` can help.

The point of the exercise is to express the problem declaratively, including its arithmetic structure, instead of enumerating all possible factor pairs in code.

## 9. Optional Further Exercises

The following problems extend the use of Z3 to more advanced encodings.

### 9.1 Longest path in a graph

The shortest path problem is efficiently solvable, but finding a longest path in a directed graph is NP-complete. Encode a longest-path problem as a Boolean constraint problem.

- Use the set of primes between 1000 and 10000 as vertices.
- Connect two vertices when their decimal representations differ in exactly one digit by 1.
- Encode an ordering for the vertices so that a prefix corresponds to a path.
- Find a compact encoding, implement it in Z3, and maximize the path length.

### 9.2 Rush Hour

Encode a Rush Hour puzzle on an `N x N` board using integer difference logic and bounded model checking.

- Represent each car or truck by its length, orientation, and fixed row or column.
- Define legal transitions between states.
- Encode bounded reachability: determine whether the target car can reach the exit within `k` moves.
- Use Z3 to solve example puzzles.

### 9.3 Queues using arrays

SMT-LIB supports the theory of arrays through `select` and `store`. Represent a queue as a triple containing an array of elements, a head index, and a tail index.

1. Specify `append`, `head`, `tail`, and `empty`.
2. Use Z3 to prove that, for a non-empty queue, appending an element does not change the head:
   `not empty(q) => head(q) = head(append(q, e))`.
3. Add a `prepend` operation.
4. Explain why `prepend(e, empty) = append(empty, e)` may not be provable under your chosen representation.

## References

- [Z3 project](https://github.com/Z3Prover/z3)
- [SMT-LIB standard](https://smt-lib.org/)
- [Z3 documentation](https://microsoft.github.io/z3guide/)
- [Project Euler, Problem 4](https://projecteuler.net/problem=4)
- [Original Z3 lab exercises](http://lim.univ-reunion.fr/staff/fred/Enseignement/AlgoAvancee/Exos/Z3-exercises.pdf)
- [Test-only development with Z3](https://community.embarcadero.com/blogs/entry/testonly-development-with-the-z3-theorem-prover-38818)
