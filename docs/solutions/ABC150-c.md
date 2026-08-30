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

## 3. Why enumerate-and-look-up, not rank arithmetic

- **Factorial-based rank computation:** O(N²) and correct, but needs careful handling of
  "how many unused values are smaller than this one" per position. More code, more places
  to be off by one. Reject — nothing here needs it.
- **Generate all, sort, `elemIndex`:** O(N! · N log N!) ≈ 40320 × 8 × 16 ≈ 5e6. Fits
  trivially, and every step is a library call. Prefer this.

The property that licenses it: N! at N=8 is small. At N=12 (479 million) this collapses
and the factorial method becomes mandatory — so the choice is constraint-driven, not
stylistic.

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
</content>
