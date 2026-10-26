# Declarative Programming with Z3

## Exercise 1: Systems of equations over integers

Consider the following puzzle:

1. There are five houses.
2. The Englishman lives in the red house.
3. The Spaniard owns the dog.
4. Coffee is drunk in the green house.
5. The Ukrainian drinks tea.
6. The green house is immediately to the right of the ivory house.
7. The smoker of Old Gold owns snails.
8. Kools are smoked in the yellow house.
9. Milk is drunk in the middle house.
10. The Norwegian lives in the first house.
11. The person who smokes Chesterfields lives next to the person who owns a fox.
12. Kools are smoked in the house next to the house where the horse is kept.
13. The smoker of Lucky Strike drinks orange juice.
14. The Japanese person smokes Parliaments.
15. The Norwegian lives next to the blue house.

In addition, someone drinks water, someone owns a zebra, and each of the five houses has a different color. Their inhabitants have different nationalities, own different pets, drink different beverages, and smoke different brands of cigarettes.

1. Encode each entity as an integer value representing the number of the house.
2. To define that the Englishman lives in a red house, add the following constraint: `(= Englishman Red)`.
3. We must constrain the value of every house so that it is between 1 and 5.
4. To define that the Norwegian lives next to the blue house, we do not know whether the Norwegian lives to its right or left, but we know that the difference between the two numbers is 1. Therefore, add the constraint:

   ```lisp
   (or (= Norwegian (- Blue 1)) (= Norwegian (+ Blue 1)))
   ```

   (Hint: as with the other constraints given in the problem, there is no overflow in this case, so this constraint works as written without checking whether the value exceeds 5.)
5. Finally, use `(distinct t1 t2 ... tn)` to specify that all entities of the same type (color, house, etc.) have different values.

## Exercise 2: Bit-vectors

### Documentation

- [SMT-LIB BitVector logic reference](http://smtlib.cs.uiowa.edu/logics-all.shtml#QF_BV)
- [Z3 tutorial on bit-vectors](http://rise4fun.com/Z3/tutorialcontent/guide#h25)

### A strange equivalent of the XOR function

Consider the following operation:

```text
(x + y - ((x & y) << 1))
```

where `<< n` is the operation "shift left n times".

Prove that this operation is equivalent to `x xor y` for any pair `(x, y)` of 64-bit bit-vectors.

Hint: the 64-bit vector containing only the value 1 can be written directly as `(_ bv1 64)`.

### Breaking a pseudorandom number generator

The default pseudorandom number generator in the C standard library is based on an [LCG (Linear Congruential Generator)](http://en.wikipedia.org/wiki/Linear_congruential_generator#Advantages_and_disadvantages_of_LCGs). Its weaknesses are well known. Let us see whether we can recover its internal state values just by observing a program's output and knowing the LCG implementation.

We will define the relationships between the LCG's internal states using Z3. Here is a test program:

```c
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
main(){
  int i;
  srand(time(NULL));
  for (i=0; i<10; i++)
    printf ("%d\n", rand()%100);
}
```

It prints 10 numbers between 0 and 99:

```text
37
29
74
95
98
40
23
58
61
17
```

Define `obs_2 = 29`, `obs_3 = 74`, ..., `obs_9 = 61`.

Let us see whether, by observing only 8 values (from 29 to 61), we can predict the next value (17).

This program was compiled with MSVC 2013 (its LCG is simpler than GLib's). Use a disassembler to identify the operations and constants it uses:

```text
.text:0040112E rand    proc near
.text:0040112E         call __getptd
.text:00401133         imul ecx, [eax+0x14], 214013
.text:0040113A         add  ecx, 2531011
.text:00401140         mov  [eax+14h], ecx
.text:00401143         shr  ecx, 16
.text:00401146         and  ecx, 7FFFh
.text:0040114C         mov  eax, ecx
.text:0040114E         retn
.text:0040114E rand    endp
```

We are ready to use Z3.

1. Declare 32-bit bit-vectors named `state1` through `state10`, `output_prev`, and `output_next`.
2. Add the following assertions connecting consecutive internal states of the LCG:
   - `state_(i+1) = state_i * 214013 + 2531011` for `i` from 1 to 9.
3. Add the following assertions connecting the LCG's internal states to the values observed in the executable's output:
   - `((state_i >> 16) & 0x7FFF) % 100 = obs_i` for `i` from 2 to 9.

   The `bvurem` function is the SMT-LIB equivalent of the modulo operation on bit-vectors.

   In the SMT-LIB script, do not declare the `obs_i` variables; use their numeric values directly as constants.
4. Add the final assertions:
   - `((state_1 >> 16) & 0x7FFF) % 100 = output_prev`
   - `((state_10 >> 16) & 0x7FFF) % 100 = output_next`
5. Check that Z3 finds the following values:

```text
sat
[state3 = 2276903645,
 state4 = 1467740716,
 state5 = 3163191359,
 state7 = 4108542129,
 state8 = 2839445680,
 state2 = 998088354,
 state6 = 4214551046,
 state1 = 1791599627,
 state9 = 548002995,
 output_next = 17,
 output_prev = 37,
 state10 = 1390515370]
```

By default, Z3 displays bit-vectors without converting them to integers. To make Z3 display bit-vectors as integers, add the following option to the formula:

```lisp
(set-option :pp.bv-literals false)
```

6. Your formula probably contains a lot of repeated code. Define functions to avoid these repetitions.
