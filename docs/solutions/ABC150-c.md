# ABC150-C — How to think about this problem

Problem: https://atcoder.jp/contests/abc150/tasks/abc150_c

This document walks through *how to arrive at the solution*, not the final code — the
implementation is left to write myself. It records the constraint read that picks the
approach, and the one library trap that silently produces wrong answers.

## 1. Read the constraints first

- **2 ≤ N ≤ 8**
- P and Q are both permutations of `(1, 2, ..., N)`.
- Time limit 2 s.

N ≤ 8 means **8! = 40320** permutations total. That is the entire hint: enumerating every
permutation is free.

Same read as ABC147-C (N ≤ 15 ⇒ enumerate all 2^N assignments). When the constraint is
absurdly small for the problem's shape, it is telling you brute force is the intended
solution — don't invent combinatorics.

## 2. Reframe the problem in your own words

The problem asks for the **lexicographic rank** of P and of Q among all N! permutations,
then `|a - b|`.

Naive-sounding framing: "compute a lexicographic rank directly." That's a real technique
(count how many permutations start with a smaller prefix, using factorials) but it's
fiddly and unnecessary here.

The reframe — the key move:

> Don't *compute* the rank. **Generate all N! permutations in lexicographic order and look
> up the position** of P and Q. With 40320 items, a linear scan is instant.

```
   all permutations of [1..3], lexicographically
   ┌─────────────────────────────────────────────┐
   │ 1: (1,2,3)                                  │
   │ 2: (1,3,2)  ← P is here    ⇒  a = 2         │
   │ 3: (2,1,3)                                  │
   │ 4: (2,3,1)                                  │
   │ 5: (3,1,2)  ← Q is here    ⇒  b = 5         │
   │ 6: (3,2,1)                                  │
   └─────────────────────────────────────────────┘
                    answer = |2 - 5| = 3
```

Matches sample 1.

### What "lexicographic order" means here

Dictionary order on sequences: compare position by position, and the first position where
they differ decides. Formally (the statement's own definition) X < Y iff there is some k
with `X_i = Y_i` for all `i < k`, and `X_k < Y_k`.

```
   (1,3,2)  vs  (3,1,2)
    ↑            ↑
    1  <  3      →  differ at position 1, so (1,3,2) is smaller.
                    Nothing after position 1 matters.

   (2,3,1)  vs  (2,1,3)
    ═            ═           position 1 ties (2 = 2)
      ↑            ↑
      3  >  1      →  differ at position 2, so (2,1,3) is smaller.
```

Consequence worth internalising: **the first element dominates**. All permutations starting
with 1 come before all starting with 2, and so on. That is why the N=3 table groups as
`(1,··) (1,··) | (2,··) (2,··) | (3,··) (3,··)` — and it's the basis of the factorial
method in §3.

## 3. Why enumerate-and-look-up, not rank arithmetic

- **Factorial-based rank computation:** O(N²) and correct, but needs careful handling of
  "how many unused values are smaller than this one" per position. More code, more places
  to be off by one. Reject — nothing here needs it.
- **Generate all, sort, `elemIndex`:** O(N! · N log N!) ≈ 40320 × 8 × 16 ≈ 5e6. Fits
  trivially, and every step is a library call. Prefer this.

The property that licenses it: N! at N=8 is small. At N=12 (479 million) this collapses
and the factorial method becomes mandatory — so the choice is constraint-driven, not
stylistic.

### How N! grows — where the cutoff sits

```
   N  │      N!      │ enumerate?
   ───┼──────────────┼─────────────────────────
   8  │       40,320 │ ✓ trivial   ← this problem
   10 │    3,628,800 │ ✓ still fine
   11 │   39,916,800 │ ~ borderline (memory hurts)
   12 │  479,001,600 │ ✗ too slow
   13 │ 6,227,020,800 │ ✗ hopeless
```

The jump is brutal — one increment of N multiplies the work by N. So "enumerate all
permutations" is safe only up to about 10, and the constraint `N ≤ 8` is a deliberate
signal that it's intended.

### The alternative, for when N is too big

Worth knowing the factorial method even though it isn't needed here, because it's the
standard tool once N > 10. It uses the "first element dominates" fact from §2:

> For each position, count how many *unused* values are smaller than the one placed there.
> Each such choice would have started a block of `(remaining)!` permutations, all of which
> come earlier.

```haskell
factRank :: [Int] -> Int          -- 0-indexed lexicographic rank
factRank [] = 0
factRank (x:xs) = smaller * product [1 .. length xs] + factRank xs
  where smaller = length (filter (< x) xs)
```

Trace on `(3,1,2)`:

```
   position 1: x=3, rest=[1,2]  → 2 values smaller → 2 × 2! = 4
   position 2: x=1, rest=[2]    → 0 values smaller → 0 × 1! = 0
   position 3: x=2, rest=[]     → 0                → 0
                                                     ───
                                       0-indexed rank = 4   (1-indexed: 5)  ✓
```

Verified: `factRank` agrees with the enumerate-and-look-up rank on **all 24** permutations
of `[1,2,3,4]`, and gives sample 2's ranks as 32094 and 14577 — matching the enumeration
method exactly (`|32094 - 14577| = 17517` ✓).

O(N²) time, O(1) space, no N! anywhere. Overkill at N=8; mandatory at N=12.

## 4. Concrete algorithm

```
perms = sort (all permutations of [1..N])     -- lexicographic order
a     = index of P in perms
b     = index of Q in perms
answer = |a - b|
```

Three library calls, all from `Data.List`: `permutations`, `sort`, `elemIndex`.

### The trap: `Data.List.permutations` is NOT sorted

This is the one thing that will silently produce wrong answers:

```haskell
permutations [1,2,3]
  ==> [[1,2,3],[2,1,3],[3,2,1],[2,3,1],[3,1,2],[1,3,2]]     -- NOT lex order

sort (permutations [1,2,3])
  ==> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]     -- lex order ✓
```

The raw order is an artefact of how the function builds the list. Ranks read off it are
meaningless. **Always `sort` the result.** Sorting 40320 lists is negligible.

**What the bug actually costs.** Without the `sort`, on sample 1:

```
   raw = [[1,2,3],[2,1,3],[3,2,1],[2,3,1],[3,1,2],[1,3,2]]

   elemIndex (1,3,2) raw = Just 5      (should be 1)
   elemIndex (3,1,2) raw = Just 4      (should be 4 — coincidentally right!)

   answer = |5 - 4| = 1        ✗   expected 3
```

Note the seductive detail: Q's index happens to be correct, so only *one* of the two ranks
is visibly wrong. This is the kind of bug that survives a partial eyeball check.

Why the raw order looks so arbitrary — for `[1,2,3,4]` it begins:

```
   [1,2,3,4], [2,1,3,4], [3,2,1,4], [2,3,1,4], [3,1,2,4], [1,3,2,4], [4,3,2,1], ...
```

`permutations` is written to be **lazy and productive** — it yields the input unchanged
first, then permutations of growing prefixes, so `take k (permutations xs)` works even on
an infinite list. Lexicographic order would require knowing the whole list up front. The
ordering is a deliberate performance property, not an oversight.

> **General habit:** a library function's output order is only guaranteed if the docs say
> so. `sort`, `sortOn`, `group`, `nub` have specified orders; `permutations`,
> `Data.Map.toList` vs insertion order, and `Data.Set` iteration are the usual surprises.
> When order matters to correctness, verify it in `ghci` on a 3-element example — it takes
> ten seconds and this bug is silent.

### 0-indexed vs 1-indexed cancels out

`elemIndex` is **0-indexed** and returns `Maybe Int`. The problem's ranks are 1-indexed, so
the true ranks are `index + 1`. But:

```
|(a+1) - (b+1)| = |a - b|
```

The offset cancels in the difference. So no `+1` is needed — worth *noticing* rather than
adding it twice for nothing. (Adding it to both is also correct, just redundant.)

`elemIndex` returning `Maybe` needs handling (`fromJust`, `maybe`, or a pattern match). P
and Q are guaranteed permutations of `[1..N]`, so the lookup always succeeds — but the type
still forces a decision.

### Worked example: sample 1

```
N = 3,  P = (1,3,2),  Q = (3,1,2)

perms = [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
                  ^^^^^                   ^^^^^
elemIndex P perms = Just 1        (0-indexed; 1-indexed rank 2)
elemIndex Q perms = Just 4        (0-indexed; 1-indexed rank 5)

answer = |1 - 4| = 3   ✓   (equivalently |2 - 5| = 3)
```

The non-obvious step is the `sort`: with raw `permutations`, P sits at index 5 and Q at
index 4, giving `1` instead of `3`.

### Worked example: sample 2 (the ranks, for regression testing)

```
N = 8
P = (7,3,5,4,2,1,6,8)   0-indexed rank 32094
Q = (3,8,2,5,4,6,7,1)   0-indexed rank 14577
                        ────────────────────
            |32094 - 14577| = 17517   ✓
```

Useful as an intermediate check: if the final answer is wrong, print the two ranks
separately and compare against these. Both the enumeration and factorial methods produce
exactly these numbers.

### Input parsing

Three lines: N, then P, then Q.

```
3
1 3 2
3 1 2
```

N is on its own line and is **redundant** — `length p` recovers it, the same
derive-don't-pass point as ABC147-C. So the first line can be discarded (`_ <- getLine`)
and the two permutations read with a space-separated int reader (`getInts`).

Output is a single integer, so plain `print` is correct here — no tuple-formatting trap
like ABC149-B.

## 5. Check the complexity

- Generating: 8! = 40320 permutations of 8 elements.
- Sorting: O(N! log N!) comparisons, each O(N) on a list of 8 → ~5e6 element comparisons.
- Two linear `elemIndex` scans: 2 × 40320.

Measured (including GHC startup via `runghc`, generating 8! and solving the worst case):
**0.40 s total**. Comfortably inside 2 s, and a compiled binary is far faster.

`elemIndex` scanning linearly is fine here — no need for a `Map`. Same lesson as ABC147-C,
where `!!` was a non-issue at N=15: **complexity rules are contextual**, re-derive the
budget per problem.

## 6. Spot-check the answer's range

Maximum possible answer is `8! - 1 = 40319` (first permutation vs last — verified). Fits
`Int` trivially. No overflow anywhere.

## 7. Lessons to carry forward

- **N ≤ 8 with permutations ⇒ enumerate all N!.** Alongside "N ≤ 20 ⇒ enumerate 2^N"
  (ABC147-C), this is the second member of the *tiny-constraint-means-brute-force* family.
  Read N before designing.
- **`Data.List.permutations` does not return lexicographic order.** Always `sort` it when
  order matters. A library function's output order is not guaranteed just because it looks
  plausible on a small example — check it.
- **A constant offset cancels inside `|a - b|`.** Recognising this avoids pointless `+1`s
  and the chance of applying one to only one side.
- **Look up rather than compute, when the search space is small.** The factorial-rank
  algorithm is the *right* answer at N=12 and needless work at N=8.
- **`elemIndex` returns `Maybe`** — even a lookup guaranteed to succeed by the problem
  constraints forces a decision at the type level.
- **Know where a brute-force ceiling sits.** `2^N` is fine to ~20, `N!` only to ~10. Both
  tables are worth memorising, because they turn a constraint into an approach instantly.
- **When debugging a difference, print both operands.** `|a - b|` collapses two numbers
  into one, hiding which side is wrong — sample 2's ranks (32094, 14577) are recorded above
  precisely so a future failure can be localised.

## Related

- [`ABC147-c.md`](./ABC147-c.md) — the `2^N` sibling of this pattern: tiny N licenses
  enumerating every configuration, with the same "derive N internally" point.
- [`../topics/gcd-lcm-and-divisibility.md`](../topics/gcd-lcm-and-divisibility.md) — the
  other place where a closed form (factorial rank here, `lcm` there) is the *right* answer
  at scale but needless work inside the given constraints.
</content>
