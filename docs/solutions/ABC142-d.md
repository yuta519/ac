# ABC142-D — How to think about this problem

Problem: https://atcoder.jp/contests/abc142/tasks/abc142_d

This document walks through *how to arrive at the solution*, not the code — I'm writing
the implementation myself. The goal is to capture the chain of reasoning so the same
moves are available next time.

## 1. Read the constraints first

- A, B up to 1e12.
- Time limit 2 s.

1e12 is the number that kills the naive approach. Enumerating `[1..A]` to collect
divisors is O(A) ≈ 1e12 iterations → far too slow. Any per-divisor loop must be bounded
by **O(√g)** where `g = gcd(A, B)` (≈ 1e6 iterations), not by A itself. Pin this down
*before* writing the loop, not after a TLE.

## 2. Reframe the problem in your own words

Naive framing: "list the common divisors, then pick the largest pairwise-coprime
subset." The picking step looks like a hard combinatorial search over subsets.

Two reframes unlock it:

> **(a) Common divisors of A and B = divisors of `gcd(A, B)`.** So there's only one
> number that matters: `g = gcd(A, B)`.

> **(b) Think in prime factors, not the numbers themselves.** Two numbers are coprime
> ⟺ they share no prime factor. A *pairwise*-coprime set therefore means **no prime is
> used by two different members**.

Under (b) the subset search dissolves: the best you can do is give each chosen number a
single distinct prime of `g` (like 4=2², 3, 5 for g=60). One number per prime — you
can't beat that. Plus `1` is coprime to everything, so it's always a free extra.

So the reframed problem is: **count the distinct prime factors of `gcd(A, B)`, add 1.**

## 3. Why prime-factor counting, not subset search

- **Subset search over divisors:** exponential in the number of divisors. Reject.
- **Count distinct primes of `g`:** the coprimality constraint is exactly "each prime
  claimed at most once," so the answer is a direct count — no search. The `+1` is the
  number 1.

The property that makes it work: coprimality is defined on shared primes, and each prime
of `g` can back at most one set member, so distinct-prime-count is both an upper bound
(can't reuse a prime) and achievable (pick `p^k` for each prime p).

## 4. Concrete algorithm

```
g = gcd(A, B)
count distinct primes of g by trial division:
    for d = 2, 3, 4, ... while d*d <= g:
        if d divides g:
            count += 1
            divide g by d until d no longer divides   -- strip the whole prime power
    if g > 1 after the loop:  count += 1               -- one prime factor left over
answer = count + 1                                     -- the +1 is the number 1
```

Invariant: after handling `d`, `g` has no prime factor `< d` remaining, so any leftover
`> 1` at the end must be a single prime larger than √(original g).

- **Edge case g = 1** (e.g. A=1): the loop never fires, leftover is not `> 1`, count
  stays 0, answer = 1. Matches Sample 3.
- **`d*d <= g`, not `sqrt`:** stay in integer arithmetic; `sqrt` forces `Double` and
  risks rounding near the boundary. (See prior note in this conversation.)

### Worked example: A=420, B=660 (answer 4)

```
g = gcd(420,660) = 60 = 2^2 * 3 * 5
d   d*d<=g?  divides?  count  g after stripping   note
2   4<=60    yes       1      15                  strip 2^2
3   9<=15    yes       2      5                   strip 3
4   16<=5    no — loop ends
leftover g=5 > 1                3                                one prime left
answer = 3 + 1 = 4
```

The non-obvious moment is the leftover check: `5` is a prime bigger than √60, so the
`d*d <= g` loop never reaches it — the post-loop `if g > 1` is what counts it.

## 5. Check the complexity

- Time: O(√g) ≤ O(√1e12) = O(1e6) trial divisions.
- Space: O(1).

Fits §1 comfortably.

## 6. Spot-check the answer's range

Answer is tiny (distinct primes of a ≤1e12 number is at most ~11, since
2·3·5·7·11·13·17·19·23·29·31 > 1e12) — fits `Int` trivially. The real trap is the
*inputs*: A, B up to 1e12 exceed 32-bit `Int`, so use 64-bit `Int` (fine on the judge)
or `Integer`. `d*d` for `d ≈ 1e6` is ≈ 1e12 — also within 64-bit.

## 7. Lessons to carry forward

- **Common divisors of A and B ⟺ divisors of `gcd(A, B)`.** Collapse two numbers into
  one before doing anything else.
- **Recast coprimality problems in terms of shared primes.** "Pairwise coprime" = "no
  prime used twice," which turns a subset search into a prime count.
- **Bound trial division by √n and strip whole prime powers.** Never loop to A when √g
  suffices; divide out each prime fully so you count *distinct* primes.
- **Handle the leftover prime after the loop.** A single prime factor `> √g` survives the
  `d*d <= n` loop — the post-loop `if g > 1` catches it. Forgetting this undercounts.
- **Use `d*d <= n`, not `sqrt`.** Integer arithmetic dodges `Double` rounding at the
  boundary.
</content>
</invoke>
