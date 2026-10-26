# CBMC Lab Assignment

In this lab, we will explore some of the features of CBMC, a tool that can perform
*bounded model checking* directly on C code. It can check assertions, detect potential
problems with pointers and array bounds, and verify selected parts of a program without
having to remove the other parts. Since CBMC performs bounded model checking, it has
limitations when dealing with infinite loops. However, it can limit the number of loop
iterations and even detect when this limit may omit behavior (that is, when a loop treated
as infinite is not actually infinite).

You can find more details about CBMC in the [manual](http://www.cprover.org/cbmc/doc/manual.pdf),
the [project website](http://www.cprover.org/cbmc/),
or the [API documentation](http://www.cprover.org/cprover-manual/api.html).

This lab provides an overview of CBMC's basic features, with the goal of understanding
its behavior and output. If you finish it, I recommend using CBMC to verify your own C code.

## Exercise 1: Assertions

1. Download [this code](./cbmc/hello.c) and open it. What is it trying to verify? Do you think the claim is true?
2. Run `cbmc file.c`. What happens?
3. `cbmc file.c --show-claims` displays all the *claims* (statements or assertions) that CBMC attempts to verify, including their names and details.
4. `cbmc file.c --claim main.assertion.1` lets you check a single assertion.
5. CBMC converts the program and its assertions into propositional-logic formulas and passes them to a SAT solver. You can inspect these formulas with the `--show-vcc` option. If you add `--slice-formula`, it will show only the constraints relevant to each assertion, which may be easier to read.

## Exercise 2: Assumptions

1. Download [this code](./cbmc/assume.c), open it, and verify it with CBMC using the options introduced above. What does the `__CPROVER_assume` function do? What happens if you remove it?
2. Download [this other code](./cbmc/assume-bis.c). Does verification succeed? Why?

## Exercise 3: Array Bounds

1. Download [this code](./cbmc/array.c). Is there a problem?
2. Run `cbmc array.c`. What happens?
3. CBMC can detect whether a program attempts to access an array out of bounds. To do this, use the `--bounds-check` option. What happens when you do?
4. Use this option together with the previous options to explore CBMC's behavior.

## Exercise 4: Pointers

1. Download [this code](./cbmc/simple.c). Do you see any problems?
2. Run CBMC on it, first without and then with `--bounds-check`. What happens?
3. CBMC can also detect pointer-related problems, such as unauthorized memory access or illegal dereferencing. Use the `--pointer-check` option to do this.
4. Try to understand what is happening (without the options mentioned above).

## Exercise 5: Loops and Functions

1. Download [this code](./cbmc/loop.c). What should happen?
2. Run CBMC on it. Is everything in order?
3. You will notice a loop in the `loop` function. CBMC fully unwinds the loop to generate its constraints. It can do so here because the loop is finite in this context, but this is not always possible. You can limit unwinding with the `--unwind n` option. Run `cbmc loop.c --unwind 3`. What happens? Why?
4. The previous test reported no errors because the assertions are not reached within three iterations. CBMC can detect this using the `--unwinding-assertions` option. Run `cbmc loop.c --unwind 3 --unwinding-assertions`. What happens? For what value of `unwind` do you obtain the desired behavior?
5. CBMC can also verify only part of a program using the `--function` option. In this case, the entry point is set to the function you specify. Run `cbmc loop.c --function loop`. What happens?
6. Run it again, but use the `--unwind` option. Is the result better?
7. Now add the `--unwinding-assertions` option. Does it work? Why? Can you find an `unwind` value for which it works?
8. If you use `__CPROVER_assume`, can you obtain a successful verification?

## Exercise 6: A Finite Loop

1. Download [this code](./cbmc/binsearch.c) and try to verify it.
2. Can you find an `unwind` value for which verification succeeds and no behavior is omitted (that is, `--unwinding-assertions` does not fail)?

## Exercise 7: Memory Allocation

1. Consider [this program](./cbmc/pointer_bounds.c). Verify it with the `--pointer-check` option. Why is there an error? Can you add a constraint on `n` so that verification succeeds?
2. Now consider [this program](./cbmc/malloc_free.c). Verify it. What happens?

## Exercise 8: Buffer Overflow

1. Consider [this program](./cbmc/buffer-overflow.c). Verify the `queue_test` function. Is there an error? Remember to use the `--bounds-check` and `--pointer-check` options.
2. Can you modify the program to eliminate those errors?
3. Even so, could your program lose some information? Devise a way to verify this with CBMC using assertions.
4. Once you have done this, try to modify your program so that the assertions hold, by reporting an error or raising an exception whenever information is lost.

## Notes

Check which version of CBMC you have installed by running `cbmc` alone.

If your version is `5.6`, `cbmc` does not display counterexamples by default (if any); you must use the `--trace` option.

## Source

* Original course material by Vincent Penelle
