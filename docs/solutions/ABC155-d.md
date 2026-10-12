# ABC155-D — How to think about this problem

Problem: https://atcoder.jp/contests/abc155/tasks/abc155_d

This document walks through *how to arrive at the solution*. Unlike the other notes here,
the final code is included — I did not solve this one myself, and the honest record is
that I asked for it after about six rounds of hints failed to land. §0 explains why that
is a reasonable outcome rather than a failure.

## 0. Calibration — this is not a normal D

From the AtCoder Problems difficulty model (fetched 2026-10-12, 413 ABC D problems with
an estimate):

```
 median ABC D        :  885
 ABC155-D            : 1845   ← 10th hardest D of 413, 98th percentile
 ABC143-D (my note)  :  686
 ABC144-D (my note)  :  714
 ABC142-D (my note)  :  827
 ABC138-D (my note)  :  920
 ABC137-D (my note)  : 1313
```

1845 is blue-level and above the usual E slot. It is roughly **1000 points harder** than
the D problems I had been working through. Two independently hard ideas have to be
composed — binary-search-the-answer *and* a sign-split counting routine — and either one
alone would be a reasonable D.

**Lesson: check the difficulty estimate before concluding I am stuck.** Six failed
rounds on an 1845 is expected; six failed rounds on an 800 is a signal to re-read.

## 1. Read the constraints first

- `2 ≤ N ≤ 2×10⁵`
- `1 ≤ K ≤ N(N-1)/2`
- `-10⁹ ≤ A_i ≤ 10⁹`
- Time limit 2 s

`N = 2×10⁵` on a *pairwise* quantity is the whole story:

- Number of pairs ≈ `N²/2` = **2×10¹⁰**. Not just too slow to sort — too many to *hold*.
- So the budget is O(N log N) or O(N log N × log(answer range)). Anything that
  materialises a pair is dead on arrival.

The negative values in `A_i` are not decoration; they are where all the difficulty lives.

## 2. Reframe the problem in your own words

Naive framing: "build all products, sort, index K." O(N² log N), and 2×10¹⁰ elements
won't fit in memory. Reject.

The reframe — the key move, and the one worth memorising:

> **Stop producing the K-th value. Ask a counting question instead.**
> Define `f(X)` = how many pairs have product ≤ X. `f` is non-decreasing in X, so the
> answer is the **smallest X with `f(X) ≥ K`** — found by binary search over X.

Why this is legal, and the detail that makes it exact: `f` only *steps up* at values that
are actually products. So the X that binary search lands on is guaranteed to be a real
product, not some value in between. Binary searching over all integers is safe.

```
 f(X) for A = [3,3,-4,-2], products -12,-12,-6,-6,8,9

  6 │                                          ┌────
  5 │                                    ┌─────┘
  4 │              ┌─────────────────────┘
  2 │     ┌────────┘
  0 │─────┘
    └──┬────┬────┬────┬────┬────┬────┬────┬────┬──→ X
     -13  -12  -11  -7   -6   -5    7    8    9

 K=3:  f(-7) = 2 < 3      f(-6) = 4 ≥ 3      → answer -6
```

Classical shape: **binary search on the answer** (a.k.a. parametric search). The tell is
"K-th smallest / largest of an implicitly-defined set too big to enumerate."

## 3. Why binary-search-the-answer, not the alternatives

- **Enumerate + sort:** O(N² log N), 2×10¹⁰ items. Fails §1. Reject.
- **Heap of size K:** K can be ~2×10¹⁰. Reject.
- **Binary search X, count pairs ≤ X:** ~61 iterations × O(N log N) count. **Fits.**

The property that makes it work: counting is *far* cheaper than enumerating, because a
sorted group lets you convert "how many partners qualify" into **one subtraction** of
indices rather than a scan.

## 4. Concrete algorithm

### Call structure — read this before any detail

```
 solveD A K
   │
   ├─ sort A                                  ← ONCE
   ├─ split into negs / zeros / poss          ← ONCE
   │
   └─ binary search X over [-10¹⁸, 10¹⁸]      ← ~61 iterations
        │  (only X changes between iterations)
        │
        └─ countLE X                          ← O(N log N), called 61 times
             ├─ zero-touching pairs   O(1) arithmetic, guarded on X ≥ 0
             ├─ neg × neg             sum over negs of a binary search
             ├─ pos × pos             sum over poss of a binary search
             └─ neg × pos             sum over negs of a binary search
```

The sign classification lives **entirely inside `countLE`**. The search layer never sees
a negative or a zero. Keeping that boundary straight is most of the battle.

### Why signs force a split

```
 sorted A:  [ -4, -2 │  0, 0  │ 3, 3 ]
              ───┬──   ──┬──   ──┬──
             negatives  zeros  positives

 neg × neg  →  positive product
 neg × pos  →  negative product      ← the inequality flips here
 pos × pos  →  positive product
 any × zero →  exactly 0
```

One uniform loop cannot work, because `a*b ≤ X` behaves differently depending on the
sign of `a`.

### The counting primitive: `partners`

Given a sorted ascending group `v` and one element `a`, how many `b ∈ v` satisfy
`a*b ≤ X`? The answer is always a **contiguous run** at one end of `v`, so it is one
index subtraction:

```
 a > 0:  a*b GROWS with b   →  qualifiers are a PREFIX
         v:      3     5    10    20    50
         a=2:    6    10    20    40   100     X=25
                 ✓     ✓     ✓     ✗     ✗
                             │
                       count = 3

 a < 0:  a*b SHRINKS with b →  qualifiers are a SUFFIX
         v:      3     5    10    20    50
         a=-2:  -6   -10   -20   -40  -100     X=-11
                 ✗     ✗     ✓     ✓     ✓
                             │
                       count = 5 - 2 = 3
```

So the sign flip is handled by **which end of the array you measure from**, not by
flipping an inequality or dividing by `a`. That is the trick that makes the code short.

### Pseudocode

```
solveD A K:
    sort A; split into negs, poss; z = count of zeros; n = |A|
    lo, hi = -1e18, 1e18
    while lo < hi:
        mid = (lo + hi) div 2            -- floor division, see §"bugs"
        if countLE(mid) >= K: hi = mid
        else:                lo = mid + 1
    return lo

countLE(X):
    zeroPairs = if X >= 0 then (n-z)*z + C(z,2) else 0
    return zeroPairs + samePairs(negs) + samePairs(poss) + crossPairs

samePairs(v):                             -- unordered pairs within one group
    ordered  = sum over i of partners(v[i], v)   -- includes i == j
    diagonal = count of i with v[i]^2 <= X       -- the i == j cases
    return (ordered - diagonal) div 2

crossPairs = sum over a in negs of partners(a, poss)

partners(a, v):                           -- how many b in v with a*b <= X
    if a > 0: return  lowerBound(i -> a*v[i] >  X, |v|)       -- prefix length
    else:     return  |v| - lowerBound(i -> a*v[i] <= X, |v|) -- suffix length
```

Invariants:

- `lowerBound p len` = first index in `[0..len]` where a monotone `p` flips False→True.
  **Used at two different levels**: over the *value* axis in `solveD` (which X?) and over
  *array indices* in `partners` (where's the boundary?). Same primitive, hence no
  separate prefix/suffix code.
- `samePairs` sidesteps all `i < j` index bookkeeping: count every ordered pair, subtract
  the `i == j` diagonal, halve. Much harder to get wrong than constrained loops, and it
  is why `negs` and `poss` share one function.

### Worked example: sample 2, `A = [5,4,3,2,-1,0,0,0,0,0]`, `K = 40`

This is the case that punishes mishandling zeros — 35 of the 45 pairs are zero.

```
 sorted:  [-1 │ 0,0,0,0,0 │ 2,3,4,5]
           1 neg   5 zeros    4 pos

 zero-touching: 5×5 + C(5,2) = 25 + 10 = 35   all products 0
 neg × pos:     1×4           =  4            -2, -3, -4, -5
 pos × pos:     C(4,2)        =  6            6, 8, 10, 12, 15, 20
 neg × neg:     C(1,2)        =  0
                                 ──
                                 45 ✓

 position:  1   2   3   4 │  5 ... 39 │ 40  41  42  43  44  45
 value:    -5  -4  -3  -2 │  0 (×35)  │  6   8  10  12  15  20
                                         ▲
                                       K=40 → 6

 f(5) = 4 + 35 + 0 = 39  < 40
 f(6) = 4 + 35 + 1 = 40  ≥ 40   → answer 6 ✓
```

The non-obvious step is the zero block: it contributes **all 35 at once** the moment X
reaches 0, and nothing at all before. It is arithmetic, never a loop.

## 5. Check the complexity

- Sort: O(N log N).
- `countLE`: O(N log N) — each of the ~N elements does one O(log N) binary search.
- Binary search over X: `log₂(2×10¹⁸)` ≈ **61** iterations.
- Total: 61 × 2×10⁵ × 18 ≈ **2.2×10⁸** simple Int ops.

Measured: **0.58 s** at N = 2×10⁵ with GHC `-O2` and `UArray`, against the 2 s limit.

`UArray` vs boxed `Array` is load-bearing here — that was the difference between
comfortable and marginal.

A two-pointer version of `countLE` is O(N) instead of O(N log N), giving ~1.2×10⁷ total.
**It is not needed**, and reasoning about pointer monotonicity across rows is the single
subtlest part of the problem. Binary search per element is the right trade: each row
becomes independent, with no persistent pointer and no ordering constraint between rows.

## 6. Spot-check the answer's range

- Products reach `10⁹ × 10⁹ = 10¹⁸`. `Int` is 64-bit (max ≈ 9.2×10¹⁸). Fits.
- Sample 3's answer is `448283280358331064` — exceeds 32-bit, confirming 64-bit is needed.
- Binary search bounds `±10¹⁸` mean `lo + hi` maxes at 2×10¹⁸. Also fits. **If `limit`
  were widened to `maxBound`, the midpoint would overflow.**

## Bugs hit along the way

### Bug 1 — guarding the zero block on the wrong thing

My first attempt:

```haskell
zeroPairs = if length zeros == 0 then 0 else (n - z) * z + z * (z-1) `div` 2
```

The *arithmetic* was right (verified against brute force on 3,900 arrays). The *guard*
asked "are there any zeros?" when the question `countLE` has to answer is "does X reach
0?". Every zero-touching pair has product exactly 0, so:

```
 X = -1  →  0 ≤ -1 false  →  contribute 0
 X =  0  →  0 ≤  0 TRUE   →  contribute all of them
```

Measured impact: **2795 failing cases**, e.g. `[5,4,3,2,-1,0,0,0,0,0]` at `X = -6` wanted
0 and got 35.

Also note it must be `X >= 0`, not `X > 0` — the boundary case counts. And the
`length zeros == 0` test was dead code: when `z = 0` the formula already yields 0.

### Bug 2 — `div` vs `quot` in the binary search midpoint

Floor division is **required**; truncating division infinite-loops. Concretely, at
`lo = -6, hi = -5` with K = 3 on sample 1:

```
 (-6 + -5) `div`  2  =  -11 `div`  2  =  -6   ← floor:    mid = lo, hi moves to -6, DONE
 (-6 + -5) `quot` 2  =  -11 `quot` 2  =  -5   ← truncate: mid = hi, hi stays -5, SPINS
```

With `quot`, `f(-5) = 4 ≥ 3` sets `hi = -5`, which changes nothing, forever. This is a
general hazard for binary search over a range that includes negatives — easy to miss
because it never triggers on non-negative ranges.

### Near-miss — `where` is not sequential assignment

Three bindings named `negs` in one `where` block is `Conflicting definitions for ‘negs’`,
not re-assignment. Related: `filter (\x -> x < 0)` inside a function whose parameter is
also `x` shadows the threshold. Use sections — `filter (< 0)` — which have no bound
variable to collide.

## The final code

In `lib/ABC155.hs`. Verified: all 3 official samples, plus 3,902 arrays checked against
brute force (every array of length 2–5 over `[-2..2]`, covering every mix of signs and
zeros).

```haskell
solveD :: [Int] -> Int -> Int
solveD as k = go (-limit) limit
  where
    limit = 10 ^ (18 :: Int)
    sorted = sort as
    negs = toArr $ filter (< 0) sorted
    poss = toArr $ filter (> 0) sorted
    n = length as
    z = n - arrLen negs - arrLen poss
    go lo hi
      | lo >= hi = lo
      | otherwise =
          let mid = (lo + hi) `div` 2
           in if countLE negs poss n z mid >= k then go lo mid else go (mid + 1) hi

countLE :: UArray Int Int -> UArray Int Int -> Int -> Int -> Int -> Int
countLE negs poss n z x = zeroPairs + samePairs x negs + samePairs x poss + crossPairs
  where
    zeroPairs
      | x >= 0 = (n - z) * z + z * (z - 1) `div` 2
      | otherwise = 0
    crossPairs =
      foldl' (\acc i -> acc + partners x (negs ! i) poss) 0 [0 .. arrLen negs - 1]

samePairs :: Int -> UArray Int Int -> Int
samePairs x v = (ordered - diagonal) `div` 2
  where
    len = arrLen v
    ordered = foldl' (\acc i -> acc + partners x (v ! i) v) 0 [0 .. len - 1]
    diagonal = length [() | i <- [0 .. len - 1], let a = v ! i, a * a <= x]

partners :: Int -> Int -> UArray Int Int -> Int
partners x a v
  | a > 0 = lowerBound (\i -> a * (v ! i) > x) len
  | otherwise = len - lowerBound (\i -> a * (v ! i) <= x) len
  where
    len = arrLen v

lowerBound :: (Int -> Bool) -> Int -> Int
lowerBound p len = go 0 len
  where
    go lo hi
      | lo >= hi = lo
      | otherwise =
          let mid = (lo + hi) `div` 2
           in if p mid then go lo mid else go (mid + 1) hi
```

Test harness kept at `scratch/ABC155D_check.hs` (outside the cabal build, so HLS does not
see it — check it with `ghc -fno-code -Wall scratch/ABC155D_check.hs`).

## 7. Lessons to carry forward

- **"K-th smallest of a set too big to enumerate" ⇒ binary search the answer.** Replace
  "produce the K-th value" with "count how many are ≤ X", which is monotone in X. This is
  the single most transferable idea in the problem.
- **`f` only steps at real elements**, so the X binary search lands on an actual member of
  the set. That is why searching over all integers is exact, not approximate.
- **Write the correct-but-slow version first, then optimise one piece at a time.** I tried
  to understand the fast counting routine before having *any* working `countLE`, and that
  was the actual reason six rounds of explanation bounced. Brute force is a checkpoint and
  a test oracle, not wasted work. (Same lesson as ABC143-D, learned harder.)
- **Exhaustive small testing beats random testing for sign bugs.** All 775 arrays of
  length 2–4 over `[-2..2]` covers every arrangement of negative/zero/positive and is
  deterministic. It found Bug 1 instantly.
- **Negatives in a binary search ⇒ check `div` vs `quot`.** Floor division is required;
  truncation can fail to make progress. (Bug 2.)
- **Handle a sign flip by changing which end you measure from, not by flipping the
  inequality.** `partners` never divides by `a`, so the `div`/`quot` trap cannot arise
  inside it and there is no `>=`-vs-`<=` case analysis to get backwards.
- **Count ordered pairs, subtract the diagonal, halve** — a cleaner route to unordered
  pairs within one group than generating `i < j` directly.
- **A group of equal elements collapses to arithmetic.** The zeros contribute
  `(n-z)*z + C(z,2)` in O(1); never loop over interchangeable items.
- **Check the difficulty estimate when stuck.** 1845 vs a median D of 885 reframes "I
  can't do this" as "this is a blue problem in a brown slot." Worth doing before
  concluding anything about my own progress. (§0.)
