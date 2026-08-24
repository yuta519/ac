# GCD, LCM, and divisibility: one identity replaces all the case analysis

This note is about the **elementary number theory** category behind ABC148-C — the
multiplicative structure of the integers. The payoff is a single formula that makes
divisibility case analysis unnecessary, plus the two ways it silently goes wrong
(returning the smaller number; integer overflow).

Write the identity into muscle memory. It shows up whenever a problem mentions common
multiples, common divisors, cycles that resynchronise, or fractions in lowest terms.

---

## The category

**Number theory → divisibility theory.** Core objects:

- **GCD** (greatest common divisor) — the largest integer dividing both `a` and `b`
- **LCM** (least common multiple) — the smallest positive integer divisible by both

And the identity linking them:

```
gcd(a, b) × lcm(a, b) = a × b
```

## Why the identity holds — the prime-exponent view

This is the picture that makes everything else obvious. Take prime factorisations:

```
a = 2^p₁ · 3^p₂ · 5^p₃ ···
b = 2^q₁ · 3^q₂ · 5^q₃ ···
```

### Reading that notation

`a` and `b` are just the two input numbers (the `a` and `b` of `solveC a b`). The claim is
that **any** positive integer can be written as a product of prime powers, so write both
inputs that way.

```
a = 2^p₁ · 3^p₂ · 5^p₃ · 7^p₄ ···
    ↑      ↑      ↑      ↑
    the primes, in order: 2, 3, 5, 7, 11, ...
```

The `p₁, p₂, p₃ …` are **exponents** — how many times each prime divides `a`. The subscript
only numbers which prime slot it refers to:

- `p₁` = exponent of 2 in `a`
- `p₂` = exponent of 3 in `a`
- `p₃` = exponent of 5 in `a`

`q₁, q₂, q₃ …` are the same for `b`; a different letter only because it's a different
number.

With real values:

```
a = 12 = 2² · 3¹ · 5⁰ · 7⁰ ···     so  p₁=2, p₂=1, p₃=0, p₄=0, ...
b = 18 = 2¹ · 3² · 5⁰ · 7⁰ ···     so  q₁=1, q₂=2, q₃=0, q₄=0, ...
```

Exponent `0` means that prime does not divide the number (`5⁰ = 1`, contributing nothing).
The `···` is just "all remaining primes, every one with exponent 0" — so the product is
finite in practice.

### Lining the exponents up as a table

This is the useful way to see it — one column per prime, handled independently:

```
   prime:      2      3      5     ...
   ─────────────────────────────────────
   a = 12:     2      1      0          ← p₁, p₂, p₃
   b = 18:     1      2      0          ← q₁, q₂, q₃
   ─────────────────────────────────────
   gcd  min:   1      1      0     →  2¹·3¹ =  6
   lcm  max:   2      2      0     →  2²·3² = 36
```

The framing turns a question about *numbers* into a question about **columns of
exponents**, where gcd and lcm are simply `min` and `max`. Per column:

```
   min(2,1) + max(2,1) = 1 + 2 = 3 = 2 + 1     ← min + max = p + q
```

which is precisely why `gcd × lcm = a × b`.

> These exponents are a **reasoning tool, never a computation.** Factorising is slow;
> Euclid's algorithm returns `gcd` without finding a single prime factor. Use the table to
> see *why* a formula is right, then use `gcd`.

Then, **per prime**:

```
gcd  takes  min(pᵢ, qᵢ)      -- the shared part
lcm  takes  max(pᵢ, qᵢ)      -- the combined requirement
```

Since `min(p,q) + max(p,q) = p + q` for every prime, multiplying gcd by lcm recovers
`a × b` exactly. This is a corollary of the **fundamental theorem of arithmetic** (unique
prime factorisation).

```
        a = 2² · 3¹          (= 12)
        b = 2¹ · 3²          (= 18)
             │    │
   gcd  →  2^min(2,1) · 3^min(1,2) = 2¹·3¹ =  6
   lcm  →  2^max(2,1) · 3^max(1,2) = 2²·3² = 36
                                     ────────
                       gcd × lcm  =  6 × 36 = 216 = 12 × 18  ✓
```

### The secondary framing: a lattice

Under divisibility the positive integers form a **lattice**, and gcd/lcm are its meet and
join:

```
         lcm(a,b)        ← join  (least upper bound)
          ╱    ╲
        a        b
          ╲    ╱
         gcd(a,b)        ← meet  (greatest lower bound)
```

"Least" in LCM is *order-theoretic* (least under divisibility), not "smallest number by
accident". Useful intuition for why the LCM of a divisible pair is the **larger** number.

## The conversion formula

Rearranged for code, dividing **before** multiplying:

```haskell
lcm a b  ==  a `div` gcd a b * b
```

Three equivalent ways to write it, all verified identical:

```haskell
-- 1. shortest — lcm is in the Prelude, alongside gcd
solveC = lcm

-- 2. avoid lcm, keep gcd — makes the identity visible, still overflow-safe
solveC a b = a `div` gcd a b * b

-- 3. avoid both — Euclid by hand
myGcd :: Int -> Int -> Int
myGcd a 0 = a
myGcd a b = myGcd b (a `mod` b)

solveC a b = a `div` myGcd a b * b
```

Both `gcd` and `lcm` are **Prelude** — no import needed.

### Euclid's algorithm

`gcd` is computed by repeatedly replacing `(a, b)` with `(b, a mod b)` until the remainder
is 0; the last nonzero value is the answer. O(log min(a,b)).

```
   myGcd 456 123  →  456 mod 123 = 87
   myGcd 123  87  →  123 mod  87 = 36
   myGcd  87  36  →   87 mod  36 = 15
   myGcd  36  15  →   36 mod  15 =  6
   myGcd  15   6  →   15 mod   6 =  3
   myGcd   6   3  →    6 mod   3 =  0
   myGcd   3   0  →  3            ← gcd
```

Then `lcm(123,456) = 123/3 × 456 = 41 × 456 = 18696`.

Note: hand-rolling `myGcd` does not make anything *safer* — it is the same mathematics as
Prelude `gcd`. Worth writing once to know it; ship the Prelude version.

## Trap 1 — case analysis that overrides the correct answer

The instinct is to special-case divisibility. Every branch below is a case the formula
already handles, and two of them were **wrong**:

```haskell
solveC a b
  | a == b = a
  | a < b && b `mod` a == 0 = a     -- ✗ returns the SMALLER
  | a > b && a `mod` b == 0 = b     -- ✗ returns the SMALLER
  | otherwise = a * b               -- ✗ only correct when coprime
```

Three separate defects:

| Input | Buggy output | Correct | Why |
|---|---|---|---|
| 2, 4 | 2 | **4** | `a \| b` ⇒ lcm is the *larger*; 2 isn't a multiple of 4 |
| 3, 9 | 3 | **9** | same |
| 4, 6 | 24 | **12** | `a*b` double-counts the shared factor `gcd = 2` |
| 123, 456 | 56088 | **18696** | `gcd = 3`, so `a*b` is 3× too big |

**Why the larger?** When `a` divides `b`, every prime exponent satisfies `pᵢ ≤ qᵢ`, so
`max(pᵢ,qᵢ) = qᵢ` throughout — the lcm *is* `b`. Sanity check: is 2 a common multiple of 2
and 4? No, `2 mod 4 ≠ 0`.

**Why `a*b` fails:** it is `gcd × lcm`, so it overshoots by exactly the shared factor.

How every case collapses:

| case | gcd | `a / gcd × b` | |
|---|---|---|---|
| `a == b` | `a` | `a` | ✓ |
| `a` divides `b` | `a` | `b` (the larger) | ✓ |
| coprime | 1 | `a·b` | ✓ |
| partial overlap | shared part | divides it out exactly | ✓ |

> **Lesson: case analysis around a correct closed form is a liability, not a safety net.**
> Each branch is a boundary you must re-verify, and a wrong branch *overrides* the correct
> fallback. If the formula covers every input, ship only the formula.

## Trap 2 — overflow, in two different places

### (a) Multiply-then-divide overflows even when the answer fits

```haskell
a * b `div` g        -- ✗ the product can overflow before the division shrinks it
a `div` g * b        -- ✓ every intermediate stays ≤ the final answer
```

Measured at `a = b = 10¹⁸`:

```
a `div` g * b   →   1000000000000000000   ✓
a * b `div` g   →   -6                    ✗ silent 64-bit wraparound
```

No error, no crash — just a wrong (often negative) answer. Always divide first.

### (b) When the *answer itself* doesn't fit, division order can't save you

```
a = 10¹⁸,  b = 999999999999999999   (coprime)
true lcm ≈ 10³⁶

a `div` g * b   →  -6527149226598858752    ✗
lcm a b         →  -6527149226598858752    ✗   even Prelude lcm
```

The LCM exceeds 64-bit `Int` entirely. The fix is the **type**, not the formula:

```haskell
solveC :: Integer -> Integer -> Integer   -- arbitrary precision
solveC a b = a `div` gcd a b * b
```

So the spot-check has two questions, not one:

1. Can an *intermediate* overflow? → divide before multiplying.
2. Can the *answer* overflow? → use `Integer`.

Read the constraint on A and B to decide: LCM ≤ 10¹⁸ fits `Int`; beyond that, `Integer`.

## Where this sits among the problems already solved

| Concept | Problem |
|---|---|
| `gcd`, prefix/suffix gcd scan | ABC125-C |
| distinct prime factors of `gcd(A,B)` | ABC142-D — see [`../solutions/ABC142-d.md`](../solutions/ABC142-d.md) |
| trial division / divisor pair enumeration to √N | ABC144-C |
| **lcm via the gcd identity** | **ABC148-C** |

Common divisors of A and B are exactly the divisors of `gcd(A,B)` — the ABC142-D unlock —
and it comes from the same `min`-per-prime structure as above.

## What to learn next in this area

- **Bézout's identity** — `gcd(a,b) = ax + by` for some integers x, y (extended Euclid).
  Gateway to modular inverses.
- **Modular arithmetic** — `mod` as a ring, fast exponentiation, inverses mod a prime.
- **Sieve of Eratosthenes** — all primes below N in O(N log log N), when trial division
  per number is too slow.

Those three cover most number-theory problems at ABC-D/E level.

## Lessons to carry forward

- **`gcd(a,b) × lcm(a,b) = a × b`.** Memorise it; derive the rest. Both functions are in
  the Prelude.
- **Think in prime exponents: gcd takes `min`, lcm takes `max`.** This single picture
  explains why lcm of a divisible pair is the larger number, and why `a*b` overshoots.
- **Prefer the closed form to divisibility case analysis.** The branches you add are
  boundaries you must prove; a wrong branch silently shadows a correct fallback.
- **Divide before multiplying** (`a / g * b`) so intermediates never exceed the answer.
- **Check both overflow questions** — intermediate *and* final. When the answer itself is
  too big, switch to `Integer`; no reordering helps.
- **A passing sample set proves little.** All three official ABC148-C samples passed while
  every divisible pair (2,4), (3,9) was wrong. Test the structural cases the samples omit:
  equal, one-divides-other, coprime, partial overlap.

---

Related: [[haskell-algorithm-ramp]] for the general practice loop.
