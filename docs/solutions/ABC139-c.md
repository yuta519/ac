# ABC139-C — How to think about this problem

Problem: https://atcoder.jp/contests/abc139/tasks/abc139_c

This walks through *how to arrive at the solution*, and ends with two Haskell
implementations: the index-based two-pointer I first reached for, and the idiomatic
pair-walking fold. Both are O(N) and pass all tests.

## 1. Read the constraints first

- N up to 1e5, heights up to 1e9.
- Time limit 2 s.

1e5 ⇒ **O(N) or O(N log N)** is the budget. O(N²) ≈ 1e10 is far too slow. This single
number is what kills the naive list-indexing solution (see §6) — pin it down *before*
writing code, not after a TLE verdict.

## 2. Reframe the problem in your own words

You stand on some square `i` and repeatedly move right to `i+1` **only while
`H[i] >= H[i+1]`**. Count the moves; maximise over all starting squares.

Naive framing: "for each start, simulate walking right." That's O(N) per start, O(N²)
total. Too slow, and also doing huge amounts of repeated work.

The reframe — the key move:

> A walk from some start is exactly a maximal **run of consecutive non-increasing
> steps**. The number of moves from the best start is the **length of the longest such
> run**, measured in *steps* (a run covering `k` squares has `k-1` moves).

So the answer doesn't depend on *where* you start in any clever way: it's a single
left-to-right scan counting the longest non-increasing streak. The per-start choice
dissolves into "find the longest streak."

## 3. Why a single linear scan, not per-start simulation

Candidate techniques:

- **Per-start simulation:** O(N²). Fails §1. Reject.
- **Single scan tracking the current streak:** O(N). Each adjacent pair `(H[i], H[i+1])`
  is examined once. The streak either extends (`H[i] >= H[i+1]`) or resets to 0. Track
  the running max. This fits the budget and matches the reframed shape exactly.

The property that makes the scan work: a non-increasing run is determined purely by
**adjacent** comparisons. Knowing `H[i] >= H[i+1]` for every consecutive pair in a
window is necessary *and sufficient* for the whole window to be a valid walk. So we
never need to look back at the run's start — only at the immediate neighbour.

> ⚠️ This is the trap I fell into first: comparing the run's *start* `H[l]` against
> `H[r]` instead of the *adjacent* pair `H[r-1]` vs `H[r]`. `H[l] >= H[r]` is necessary
> but **not sufficient** — `[10,4,8]` has `10>=8` true, but the run already broke at
> `4 -> 8`. Compare neighbours, not endpoints.

## 4. Concrete algorithm

```
cur  = 0          -- length (in moves) of the streak ending at the current position
best = 0          -- best streak seen so far
for each adjacent pair (a, b) left to right:
    if a >= b:  cur = cur + 1;  best = max best cur     -- step allowed, extend
    else:       cur = 0                                 -- break, reset streak
answer = best
```

Invariant: after processing pair `(H[i], H[i+1])`, `cur` is the number of moves in the
longest valid walk that *ends at square i+1*, and `best` is the max over all positions
seen. Recording `best` on **every** extension (not just at the end) is what catches a
run that ends in the middle of the array — the exact bug that made `[5,4,3,9,8]`
return 1 instead of 2.

### Worked example: `[10, 4, 8, 7, 3]` (answer 2)

```
pair      a>=b?   cur after   best after   note
(10,4)    yes     1           1            run 10>=4
(4,8)     no      0           1            break (4 < 8)
(8,7)     yes     1           1            new run starts
(7,3)     yes     2           2            run 8>=7>=3  ← the answer
```

The non-obvious moment is row 2: the break resets `cur` to 0, but `best` keeps the 1.
Then the second run grows to 2 and overtakes it.

## 5. Check the complexity

- Time: O(N) — one pass over N-1 adjacent pairs.
- Space: O(N) for the array version, O(1) extra for the fold version.

Fits §1 comfortably (N=1e5 runs in ~0.6 s including GHC startup).

## 6. Spot-check the answer's range

Answer is at most N-1 ≈ 1e5 — fits `Int` trivially. Heights up to 1e9 fit `Int`
(64-bit on the judge). No products, no overflow risk here.

The real "range" gotcha is **time**, not value: the list-indexing version below is
correct but O(N²) and TLEs on the big cases.

## Two implementations

### Version 1 — index-based two-pointer (what `lib/ABC139.hs` ships)

`l` anchors the start of the current run, `r` is the cursor; `r - l - 1` is the move
count of the run `[l, r)`. Indexes a `Data.Array` so each lookup is O(1).

```haskell
import Data.Array (Array, listArray, (!))

solveC :: [Int] -> Int
solveC hs = go 0 1 0
  where
    n = length hs
    arr :: Array Int Int
    arr = listArray (0, n - 1) hs
    go l r cur
      | r >= n                   = max (r - l - 1) cur
      | arr ! (r - 1) >= arr ! r = go l (r + 1) (max (r - l - 1) cur)
      | otherwise                = go r (r + 1) (max (r - l - 1) cur)
```

Three things this version gets right, each of which was a bug at some point:

1. **Terminating guard first** (`r >= n`). Without it `r` runs off the end and
   `arr ! r` crashes — `>=`/`<` are exhaustive so an `otherwise` "stop" never fires.
2. **Adjacent comparison** `arr ! (r-1) >= arr ! r`, not `arr ! l >= arr ! r` (see §3).
3. **Record the max in the break branch too** (`otherwise`). A run that ends mid-array
   is otherwise never recorded.

### Version 2 — idiomatic pair-walking fold (the "Haskell-native" shape)

No indexing at all. `zip hs (tail hs)` produces the adjacent pairs; `foldl'` threads the
`(cur, best)` accumulator — the same state-threading idea as
[`../topics/threading-state-through-recursion.md`](../topics/threading-state-through-recursion.md),
but over a list instead of a recursion tree.

```haskell
import Data.List (foldl')

solveC :: [Int] -> Int
solveC hs = snd (foldl' step (0, 0) (zip hs (tail hs)))
  where
    step (cur, best) (a, b)
      | a >= b    = (cur + 1, max (cur + 1) best)  -- extend the streak
      | otherwise = (0, best)                      -- break, reset to 0
```

Why this is the more natural Haskell:

- **No `!!`, no array, no manual indices** — so the O(N²) and off-by-one index traps
  simply can't happen. The structure of the data (consecutive pairs) is expressed
  directly.
- `zip hs (tail hs)` is the standard "adjacent pairs" idiom. Learn it once; it shows up
  constantly (differences, runs, monotonic checks).
- `foldl'` (strict!) carries the accumulator. Use `foldl'` from `Data.List`, **not**
  lazy `foldl` — lazy folds build a thunk chain of size N and blow the stack / waste
  memory on 1e5 elements.

Mapping between the two: `cur` here = `r - l - 1` there (current run length in moves);
`best` here = `cur` there (running max). Same algorithm, different skeleton.

## 7. Lessons to carry forward

- **Reframe "for each start, simulate" into "find the longest run."** Per-start
  simulation is the naive O(N²) framing; recognising it as one linear scan over the
  whole array is the unlock. When choices look per-item but the items are processed
  left-to-right, ask whether a single sweep with an accumulator replaces the loop.
- **Compare adjacent elements, not endpoints.** For monotonic-run problems the
  governing condition is local (`H[i]` vs `H[i+1]`). Comparing against a fixed anchor is
  a classic and silent correctness bug.
- **Record the running max at every step, including on a reset.** A best-so-far that's
  only captured at the array's end misses runs that end in the middle. Verify with a
  case whose optimum is *not* a suffix (e.g. `[5,4,3,9,8]`).
- **`!!` on a list is O(index) ⇒ O(N²) loops ⇒ TLE.** This is the recurring Haskell
  competitive-programming tax. Reach for `Data.Array`/`Data.Vector` for random access,
  or restructure to consume the list head-on (`zip`, folds, scans) so you never index.
  Same lesson as ATC001-A.
- **Prefer the structural solution when it exists.** Version 2 can't have the index
  bugs Version 1 had, because it has no indices. When a fold/scan expresses the problem
  directly, it's usually both safer and shorter.
