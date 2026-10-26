# Task 3

## Improved Encoding for the N-Queens Problem

Modify your n-queens program to accept the following flags:

```bash
n_queens --quad
n_queens --log
n_queens --heule
```

Each flag selects a different encoding of the At Most One (AMO) constraints.

- `--quad` uses the naive quadratic encoding (the one from last week).
- `--log` uses the logarithmic encoding.
- `--heule` uses Heule's encoding.

For each encoding, what is the smallest input value `n` for which your program takes more than 5 seconds to run on your computer?
