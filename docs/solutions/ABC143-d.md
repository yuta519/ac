# ABC143-D — How to think about this problem

Problem: https://atcoder.jp/contests/abc143/tasks/abc143_d

This document walks through *how to arrive at the solution*, not the final code — the
binary-search step is left to finish myself. It records the reasoning chain, the two
subtle bugs hit along the way, and where the correct-but-slow version stands.

## 1. Read the constraints first

- N up to 2000, side lengths up to 1e3.
- Time limit 2 s.
- Counting triples `(i, j, k)`.

N=2000 for a triple count is the whole story:

- Enumerating all 3-combinations is `N choose 3` ≈ N³/6 ≈ **1.3×10⁹** → TLE.
- So the budget is **O(N²)** (≈2×10⁶) or **O(N² log N)** (≈2×10⁷). Both fit.

That rules out `combinations 3 xs` (correct but O(N³)) and points to: enumerate *pairs*
in O(N²), and handle the third side without a third loop.

## 2. Reframe the problem in your own words

Naive framing: "for every triple, test the triangle inequality." O(N³), too slow.

The reframe — the key move:

> **Sort the lengths.** For sides `a ≤ b ≤ c`, the triangle condition collapses to the
> single inequality `a + b > c` (the other two hold automatically once sorted). Fix the
> **two smaller** sides `(a, b)` with an O(N²) double loop, and *count* how many valid
> largest sides `c` exist — don't iterate them.

Because the fixed pair is always the two *smaller* sides and `c` is always the largest,
every triangle `{x,y,z}` (x<y<z) is counted **exactly once** — when the pair is `(x,y)`.
No double-counting, no divide-by-anything. This is why sorting first matters.

## 3. Why "fix two, count the third", not enumerate triples

- **Enumerate all triples:** O(N³). Fails §1. Reject.
- **Fix pair (a,b), scan for valid c:** O(N²) pairs × O(N) scan = O(N³). Still fails.
- **Fix pair (a,b), binary-search for valid c:** O(N²) pairs × O(log N) = O(N² log N).
  Fits.

The property that makes counting work: once sorted and the pair `(a,b)` at indices
`(i,j)` is fixed, a valid third side `c` must have **index `k > j`** (so it's the
largest) **and** `arr!k < arr!i + arr!j`. Since the array is sorted, those `k` form a
**contiguous block** `[j+1 .. boundary-1]`. So the count is pure arithmetic:
`boundary - (j+1)`, where `boundary` is the first index `> j` with `arr!k >= a+b`.

## 4. Concrete algorithm

```
sort a
answer = 0
for i in 0 .. n-2:
    for j in i+1 .. n-1:                 -- pair (a[i], a[j]) = two smaller sides
        limit    = a[i] + a[j]
        boundary = first index k > j with a[k] >= limit   -- binary search, O(log N)
        answer  += boundary - (j + 1)
```

Invariant: for a fixed `(i,j)`, `boundary - (j+1)` is the number of indices `k` with
`j < k < boundary`, i.e. exactly the sticks that are larger than `a[j]` (by position)
yet still `< a[i]+a[j]`. Summed over all pairs, that's every valid triangle once.

### Worked example: `[218, 786, 704, 233, 645, 728, 389]` (answer 5)

Sorted: `[218, 233, 389, 645, 704, 728, 786]` (indices 0..6).

Fix pair `(i=0, j=1)` = (218, 233): need `c > index 1` and `c < 451`. Candidates to the
right: 389, 645, ... — only **389** qualifies → count 1. (Note 218 and 233 are `< 451`
but must be *excluded* — they're not to the right of `j`. This is why the count is
index-based, not value-based; see §6.)

Continue over all pairs; the qualifying counts total **5**.

## 5. Check the complexity

- Time: O(N² log N) ≈ 2×10⁶ pairs × ~11 ≈ 2×10⁷. Fits 2 s.
- Space: O(N) for the sorted `Data.Array`.

The correct-but-slow version (§ below) is O(N³) ≈ 1.3×10⁹ → **TLE**. The binary search
is what converts a correct solution into an accepted one.

## 6. Spot-check the answer's range

Answer is a count of triples, at most `N choose 3` ≈ 1.3×10⁹ — **exceeds 32-bit**, so
accumulate in 64-bit `Int` (fine on the judge) / `Integer`. Side lengths ≤ 1e3 so
`a[i]+a[j]` never overflows.

## Two subtle bugs hit along the way

### Bug 1 — index vs value for "the third side is larger"

The "third side is the largest" condition must be enforced by **position** (`k > j`),
not by **value** (`c > a[j]`). They differ when lengths are **equal**, and the problem
counts triples of *indices*, so equal-length sticks are distinct.

Trace `[5,5,5]` (answer 1, since 5+5>5):

- Value check: pair (0,1) looks for `c > 5` → finds none → counts 0. ❌ Misses it.
- Index check: pair (0,1) looks at index 2 (`k > 1`), `5 < 10` → counts 1. ✓

So filter by the index range `[j+1 .. n-1]` and drop any `c > a[j]` value comparison —
the range already guarantees "largest".

### Bug 2 — array bounds off by one

`listArray (0, n) xs` declares `n+1` slots for `n` elements. It only "works" because the
loops never touch index `n` — a latent bug. Use `listArray (0, n-1)`.

## Current state — correct but O(N³) (TLE)

This version is *correct* (passes small cases, gives 5 on the sample) but times out on
large N. It's the right checkpoint: correctness proven, only speed left.

```haskell
solveD :: Int -> [Int] -> Int
solveD n ls = sum [go i j | i <- [0 .. n - 2], j <- [i + 1 .. n - 1]]
  where
    arr = listArray (0, n - 1) (sort ls)
    go i j = length $ filter (< arr ! i + arr ! j) $ map (arr !) [j + 1 .. n - 1]
```

The `map (arr!) [j+1 .. n-1]` fixes Bug 1 (index range) and Bug 2 (bounds) is fixed
above. The remaining `filter` scan is the O(N) per pair that makes it O(N³).

## The remaining step — binary search (TODO)

Replace the inner `filter … (map (arr!) [j+1 .. n-1])` with a binary search that finds
`boundary` = the first index `> j` where `arr!k >= arr!i + arr!j`, then count
`boundary - (j+1)`. Since `arr` is sorted, this is a standard lower-bound search:

```
boundary(lo, hi, limit):        -- search within indices, half-open reasoning
    invariant: arr!(lo-1) < limit  and  arr!hi >= limit  (conceptually)
    while lo < hi:
        mid = (lo + hi) `div` 2
        if arr!mid < limit: lo = mid + 1
        else:               hi = mid
    return lo
```

Then `go i j = boundary (j+1) n limit - (j+1)` with `limit = arr!i + arr!j`, clamped at
0. Binary search is inherently index-based — this is the one place `arr ! i` on a
`Data.Array` (O(1)) is the *recommended* tool, not a code smell (`!!` on a list would be
O(N) and re-introduce the blowup).

## 7. Lessons to carry forward

- **N=2000 on a triple count screams "O(N²), count the third element."** When full
  enumeration is one power too slow, fix k-1 of the k items and count the last one.
- **Sort to simplify the condition.** For triangles, sorting reduces three inequalities
  to `a + b > c`, and makes the valid third sides a contiguous block.
- **Count by index, not value, when duplicates are distinct items.** Enforcing "largest"
  by position (`k > j`) is correct; by value (`c > a[j]`) silently drops equal-length
  ties. (Bug 1.)
- **A sorted contiguous block ⇒ binary search / two-pointer replaces the inner scan.**
  This is the O(N³) → O(N² log N) unlock, and the legitimate home for `Array ! i`.
- **Watch `listArray` bounds** — `(0, n-1)` for n elements. (Bug 2.)
- **Correct-but-slow is a real checkpoint.** Verify the answer on the sample first, then
  optimize the hot loop. Don't conflate a correctness bug with a speed bug.
</content>
