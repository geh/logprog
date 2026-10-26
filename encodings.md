# Encodings into SAT

This note covers SAT encodings for **at-most-one (AMO)** and general **cardinality constraints**.

## 1. What is a SAT encoding?

SAT solvers operate on propositional formulas in conjunctive normal form (CNF).
To solve a combinatorial problem with a SAT solver, its constraints must be represented in this language.

An encoding of a constraint `C` is a CNF formula `F` that expresses `C`, such that solutions of `C` correspond to models of `F`.

Encodings can differ in:
- the number of clauses and auxiliary variables they introduce;
- how effectively unit propagation detects conflicts and infers assignments.

## 2. At-most-one constraints

An **at-most-one (AMO)** constraint over Boolean variables `x_0, ..., x_(n-1)` requires that at most one variable is true:

```text
x_0 + ... + x_(n-1) <= 1
```

### 2.1. Pairwise (quadratic) encoding

Use the original variables only. For every pair `i < j`, add the clause:

```text
(not x_i) or (not x_j)
```

This prevents any two variables from being true simultaneously.

- Auxiliary variables: none.
- Clauses: `n(n-1)/2`, which is `O(n^2)`.

This encoding is simple and arc-consistent under unit propagation.

### 2.2. Logarithmic encoding

Introduce `m = ceil(log2(n))` auxiliary Boolean variables `y_0, ..., y_(m-1)`. Associate each `x_i` with a distinct `m`-bit binary code. For every `x_i` and each bit position `j`, add a clause that says: if `x_i` is true, then `y_j` must equal bit `j` of the code assigned to `i`.

For example, if bit `j` of `i` is 1, add:

```text
(not x_i) or y_j
```

If that bit is 0, add:

```text
(not x_i) or (not y_j)
```

Two different `x_i` variables require different codes, so they cannot both be true.

- Auxiliary variables: `O(log n)`.
- Clauses: `O(n log n)`.

### 2.3. Heule encoding

For `n <= 3`, use the pairwise encoding. For `n >= 4`, introduce an auxiliary variable `y` and recursively encode these two AMO constraints:

```text
AMO(x_0, x_1, y)
AMO(y, x_2, ..., x_(n-1))
```

The shared variable `y` links the two parts. This encoding uses `O(n)` auxiliary variables and `O(n)` clauses.

Other AMO encodings are possible; these examples illustrate the trade-off between formula size and auxiliary variables.

## 3. Consistency and arc consistency

Suppose assignments to the variables of a constraint correspond to partial assignments to the Boolean variables in its encoding.

An encoding is **consistent** if, whenever a partial assignment cannot be extended to any solution of the original constraint, unit propagation on the encoded formula detects a conflict.

An encoding is **arc-consistent** if it is consistent and unit propagation also removes values that have no support in any solution.

These properties are useful because SAT solvers perform unit propagation efficiently.

For an AMO constraint:
- **Consistency:** if two or more `x_i` variables are assigned true, unit propagation produces a conflict.
- **Arc consistency:** in addition to detecting that conflict, if one `x_i` is true, unit propagation sets every other `x_j` to false.

The pairwise, logarithmic, and Heule encodings described above are arc-consistent.

## 4. Cardinality constraints

A **cardinality constraint** limits the number of true variables. Its general form is:

```text
x_1 + ... + x_n <= k
x_1 + ... + x_n <  k
x_1 + ... + x_n >= k
x_1 + ... + x_n >  k
x_1 + ... + x_n =  k
```

Here each `x_i` is Boolean, interpreted as 0 or 1. AMO is the special case `x_1 + ... + x_n <= 1`.

### 4.1. Naive encoding

For a constraint of the form:

```text
x_1 + ... + x_n < k
```

add one clause for every choice of `k` distinct variables. Each clause forbids all `k` chosen variables from being true simultaneously:

```text
(not x_i1) or (not x_i2) or ... or (not x_ik)
```

The encoding has `C(n, k)` clauses, which can be very large.

More efficient (and complex) encodings of cardinality constraints, such as adder-based and sorting-network encodings,
introduce auxiliary variables to reduce the number of clauses or improve unit propagation.

## References

- N. Een and N. Sorensson, “Translating Pseudo-Boolean Constraints into SAT,” *JSAT*, 2(1–4), 1–26, 2006.
- R. Asin, R. Nieuwenhuis, A. Oliveras, and E. Rodriguez-Carbonell, “Cardinality Networks: a theoretical and empirical study,” *Constraints*, 16(2), 195–221, 2011.
- I. Abio, R. Nieuwenhuis, A. Oliveras, and E. Rodriguez-Carbonell, “A Parametric Approach for Smaller and Better Encodings of Cardinality Constraints,” *Principles and Practice of Constraint Programming*, 2013.
- I. Abio, *Solving hard industrial combinatorial problems with SAT*, PhD thesis, 2013.
