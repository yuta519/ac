# Type-system ramp

This is the companion to [`haskell-algorithm-ramp.md`](haskell-algorithm-ramp.md). That one
builds *algorithm* skill. This one builds *type-system* skill. They are separate tracks
because AtCoder trains one of them and not the other.

## Why a separate track is needed

Measured across `lib/` at 72 modules / ~1,500 lines:

| construct | files using it |
| --------- | -------------- |
| `data`     | 0 |
| `newtype`  | 0 |
| `class`    | 0 |
| `instance` | 0 |
| `type`     | 0 |

Every `solve` signature is a primitive or a list of primitives — `Int -> Int -> Int`
(21×), `[Int] -> Int` (17×), `String -> String` (10×).

This is not a discipline failure. **Contest problems hand you integers and ask for an
integer**, so the problem statement never contains a domain worth modelling, and nothing
ever pushes you toward `data`. AtCoder is a near-perfect algorithms teacher and a
structurally weak type-system teacher.

Consequence: every phase below imposes an **artificial constraint**, because the problems
will not impose one. Re-solving an old problem under a constraint is worth more here than
solving a new problem without one.

---

## The model: 操作から意味へ (Naoya Ito)

The target for this repo is the skill set [naoya.dev](https://naoya.dev/home) demonstrates —
AtCoder in Haskell, gray → blue, with a body of writing on why the functional style is a
weapon rather than a handicap in contests.

**His site tagline is the thesis: *"Abstract over structure, not over operations."***

### What he actually claims

From *操作から意味へ ─ Haskell が変えた私のメンタルモデル* (2025-12-05):

- A language is a 思考の外部化装置 — an externalization device for thought. Imperative
  languages make assignment, `for` and `if` primitive, so what you externalize is
  **操作** (bundles of operations). Haskell makes `map` and `fold` primitive, so what you
  externalize drifts toward **意味** (structural meaning).
- The beginner mentally *simulates* `map`/`fold` like a loop. The arrival point is reading
  `map (+1) xs` directly as "the image of xs" and never consulting the operational
  behaviour at all. He compares it to a bilingual finally processing English as English
  instead of translating.
- `map` and `fold` are the two natural operations on recursive data structures, which is
  why code text can coincide with structural meaning.
- His worked reversal is **binary search**: not "look at the middle, go left or right"
  (motion) but "locate the boundary where a predicate flips true → false" (meaning). He
  keeps a library function so the mechanics never need re-deriving:

```hs
-- | 左が true / 右が false で境界を引く
bisect2 :: (Integral a) => (a, a) -> (a -> Bool) -> (a, a)
bisect2 (ok, ng) f
  | abs (ng - ok) == 1 = (ok, ng)
  | f m = bisect2 (m, ng) f
  | otherwise = bisect2 (ok, m) f
  where m = (ok + ng) `div` 2
```

The higher-order argument *is* the boundary's meaning. Reach for binary search → ask "how
do I express the boundary as a predicate", not "how does the loop go".

### The central contest idiom

From *永続データプログラミングと競技プログラミング*:

| imperative, ephemeral data | persistent data |
| -------------------------- | --------------- |
| 「何かをしながら、何かをする」 | 「何かをしたあと、何かをする」 |
| mutate the array *while* bumping a counter | finish **all** state transitions, keep the whole history, *then* fold the history for the answer |
| old state destroyed → the two computations can't be separated → nested loops | computations split into small independent functions, flat code |

The move is: **generate every intermediate state with `iterate` or `scanl`, then search
that history with `findIndex` / `elemIndex` / `takeWhile` / `length`.** Persistent data
structures (`Set`, `Map`, `IntMap`) make it affordable, because versions share nearly all
their nodes — he holds 5×10⁵ snapshots of a 5×10⁵-element set with no MLE.

### The comparison that matters: ABC081-B

He uses ABC081-B as his flagship example, and **this repo already has it**
(`lib/ABC081.hs:7`):

```hs
-- yours: hand-rolled recursion, per element, counting divisions (操作)
solveB xs = minimum (map count2power xs)
count2power n
  | n == 0 = 0
  | n `mod` 2 /= 0 = 0
  | otherwise = 1 + count2power (n `div` 2)

-- his: the infinite history of the whole array halving, then find the boundary (意味)
solveB as = fromJust $ findIndex (any odd) (iterate (map (`div` 2)) as)
-- or
solveB as = length $ takeWhile (all even) $ iterate (map (`div` 2)) as
```

Both correct, both O(n log A) — verified identical on the official samples. The difference
is entirely in what the code *says*. His version needs laziness to exist at all, because
`iterate` is infinite. See
[`foldr-foldl-and-laziness.md`](foldr-foldl-and-laziness.md).

### The measured gap

His whole toolkit, counted across `lib/`:

| combinator | files | | combinator | files |
| ---------- | ----- |-| ---------- | ----- |
| `scanl`      | 8 | | `findIndex`    | **0** |
| `iterate`    | 1 | | `elemIndex`    | **0** |
| `takeWhile`  | 1 | | `Set.map`      | **0** |
| `foldl'`     | 10 | | `IntMap`      | **0** |
| | | | `unfoldr` / `span` / `until` | **0** |
| | | | `subsequences` / `sequence` | **0** |

`scanl` is the head start — keep pulling on it. The right-hand column is the search half
of the history idiom, and it is entirely missing.

### Correction to this doc's original emphasis

The first draft of this ramp pushed `class`/`instance`/`Monoid` hard and ended at GADTs.
**That is not his path, and it over-weights academic type machinery.** His writing is
nearly silent on typeclasses and type-level programming; what he actually credits is:

1. `map` / `fold` / `filter` read as meaning, not motion
2. recursive and **persistent** data structures
3. immutability forcing computation into function application
4. higher-order functions carrying the semantics (the `bisect2` predicate)
5. algebraic data types for modelling — his one genuinely type-focused piece is
   *TypeScript の Discriminated Union と Haskell の代数的データ型*
6. function composition, types, monads — named as contributors, not elaborated

So: Phases 2 (ADTs), 5 (folds/laziness) and the new Phase 3.5 below are the Naoya core.
Phase 3's `Monoid` work stays — it's the honest formalisation of "fold はモノイドの結合
である", which he states in one line — but it is a means, not the destination. Phase 8
(GADTs) is explicitly *beyond* him; keep it as optional.

He also downplays the usual Haskell sales pitch (robustness, safe refactoring). His stated
motive is cultivating よりよいプログラミングの目 — a better eye for programming. That is
much closer to the reason this repo exists.

---

## Phase 0: stop writing A problems

Current distribution: 137 `solveA`, 117 `solveB`, 103 `solveC`, **22 `solveD`**.

The A problems taught input parsing by roughly problem 10. The other ~127 taught nothing.
All real growth is happening in the thin D layer.

**Rule:** C and D only, unless a specific A problem exercises a library you have not used.

---

## Phase 1: turn on the compiler's help

One-time setup, do this first — later phases depend on it.

Add to both stanzas in `ac.cabal`:

```
ghc-options: -Wall -Wincomplete-patterns -Wname-shadowing
```

This immediately surfaces three real issues already in the repo:

```
lib/ABC093.hs:12    min = s !! 0
lib/ABC125.hs:24    min = minimum $ map abs as
lib/ABC155.hs:20    max = maximum [length x | x <- sorted]
```

Each shadows a Prelude name, hiding `min`/`max` for the rest of that function. Legal, and
the code is correct — but a reader must now check which `min` is meant. Fix by naming the
value for *what it is* (`longestRun`, `smallestAbs`), not for the operation that made it.

Also in this phase: the two `[Int] -> Float` signatures should be `Double`. Single
precision carries ~7 digits, which is enough to lose a problem on a precision check.

---

## Phase 2: `newtype` and `data` on re-solves

**Constraint:** no `solve` may take or return a bare `Int` where a domain concept exists.

Grid and graph problems want this most:

```hs
newtype Pos = Pos (Int, Int) deriving (Eq, Ord, Show)
data Cell   = Wall | Open    deriving (Eq, Show)
data Dir    = North | South | East | West
```

| # | re-solve | what the types buy you |
| - | -------- | ---------------------- |
| 1 | ATC001-A  | `Pos` makes the (x,y)/(y,x) swap a type error instead of a wrong answer |
| 2 | ABC088-D  | `Cell` replaces `Char` comparisons against `'#'` with exhaustive patterns |
| 3 | ABC126-D  | a two-constructor colour type instead of `Int` parity |
| 4 | ABC154-A  | its `(String, Int) -> (String, Int) -> String -> (Int, Int)` signature is begging for a record |

What to notice: with `-Wincomplete-patterns` on, adding a constructor to `Cell` makes GHC
list every place that must change. That is the type system doing work no test can do.

Related: [`threading-state-through-recursion.md`](threading-state-through-recursion.md)
already uses `Set (Int, Int)` for `visited` — `Set Pos` is the same code, better typed.

---

## Phase 3: your first instances, via `Monoid`

**The highest-value phase for this goal.** Prefix sums and range queries *are* monoids, so
this is the one place contest problems genuinely want a typeclass.

```hs
newtype RangeMin = RangeMin Int
instance Semigroup RangeMin where
  RangeMin a <> RangeMin b = RangeMin (min a b)
instance Monoid RangeMin where
  mempty = RangeMin maxBound
```

Build three: range-sum, range-min, and a max-subarray accumulator. Then solve via
`foldMap` instead of a hand-written loop.

| # | problem | focus |
| - | ------- | ----- |
| 1 | ABC139-C | fold with a "current run / best run" accumulator — write it as a `Monoid` |
| 2 | ABC147-C | combine partial results; associativity is the whole trick |
| 3 | ABC150-C | precompute once, query many — `foldMap` shape |

The test for understanding: explain *why* the operation must be associative, and what
breaks if `mempty` is wrong.

---

## Phase 3.5: the history idiom — `iterate`, `scanl`, `findIndex`

**The Naoya core.** Constraint: **no loop that transitions state and computes the answer at
the same time.** Transition first, keep every snapshot, search the snapshots after.

```hs
history = iterate step initial        -- or: scanl step initial inputs
answer  = findIndex done history      -- or: length . takeWhile notDone
```

| # | problem | focus |
| - | ------- | ----- |
| 1 | ABC081-B (re-solve) | halve the whole array with `iterate`, then `findIndex (any odd)` — compare against your `count2power` |
| 2 | ABC311-A | `scanl (flip Set.insert) Set.empty` then `elemIndex` the target set |
| 3 | ABC307-C | grid as `Set (Int,Int)`; shift with `Set.map (+ (dx,dy))`, then `or` over candidates |
| 4 | ABC322-D (Polyomino) | pre-generate **all** 192 transformed pieces, *then* brute-force triples — the payoff case |

Two sub-skills this unlocks:

- **Grid as `Set (Int,Int)`, not `Array`.** `Set.map (+ (dx,dy))` translates a shape in one
  expression; `Set.disjoint` tests overlap; `foldl1 Set.union` merges. Currently `Set.map`
  is in 0 files. This is how he makes ABC322-D tractable.
- **Why holding the history is affordable.** `IntMap`/`Set` versions share nodes, so N
  snapshots are not N copies. Read *永続データプログラミングと永続データ構造* (2024-12-03)
  and then convince yourself by measuring, not by trusting it.

Also worth stealing outright: put `bisect2` (above) in a `lib/Lib.hs` alongside `IOUtils`
and stop re-deriving binary search bounds. A personal library of semantic primitives is
itself part of his method — his has `scanForM`, grid-as-set helpers, `printYn`,
`IntMultiSet`.

---

## Phase 4: totality — `Maybe` and `Either`

**Constraint:** `head`, `!!`, `last`, and bare `read` are banned from new code.

Currently `head` is in 8 files, `!!` in 9, `read` in 6 — while `Maybe` is in 2 and
`Either` in 0.

The idea: some signatures lie. `head :: [a] -> a` cannot keep its promise on `[]`, so it
crashes at runtime. `listToMaybe :: [a] -> Maybe a` tells the truth, and the compiler then
forces you to handle the gap.

```hs
parsePair :: String -> Maybe (Int, Int)
parsePair s = do
  [a, b] <- Just (words s)   -- not exactly two words -> Nothing
  x <- readMaybe a           -- not a number          -> Nothing
  y <- readMaybe b
  pure (x, y)
```

Three failure modes, no `if`, no crash — the `do` block short-circuits at the first
`Nothing`. This is where [`monads-in-practice.md`](monads-in-practice.md) stops being
theory: `Maybe` is the cheapest monad that actually earns its keep.

Be clear-eyed about motivation: AtCoder guarantees well-formed input, so this is **not** a
correctness fix. It is a deliberate exercise. Natural places where it costs nothing:

- `Map.lookup` already returns `Maybe` — lean in rather than reaching for `fromJust`
- parsing: `readMaybe` over `read`
- `find`, and any search that may not succeed

Worth doing once for contrast: `lib/ABC155.hs:20` uses `head x` on a `group` result, which
is safe *by an invariant you happen to know* but cannot be proven by the compiler.
Rewriting it shows the difference between that and safe *by construction*.

---

## Phase 5: `foldr` and laziness, deliberately

Current state: `foldl'` in 10 files, `foldr` in **zero**, a `go` helper in 24.

A fold is recursion that someone already wrote and named:

```hs
foldl' f z [a,b,c]  ==  ((z `f` a) `f` b) `f` c     -- accumulate left, strict
foldr  f z [a,b,c]  ==  a `f` (b `f` (c `f` z))     -- build from the right, lazy
```

`foldl'` buys legibility, not power. `foldr` buys something otherwise unavailable: it can
**stop early** and **consume an unbounded list**.

```hs
foldr (\x acc -> x > 100 || acc) False [1..]   -- True, terminates
```

That walks an infinite list and stops at 101, because `||` never forces `acc` once the
left side is `True`. `foldl'` on `[1..]` runs forever. This is why `any`, `or`, `find` and
`takeWhile` are all `foldr`-shaped.

**Exercise:** convert five existing `go` helpers. The best candidate is `lib/ABC153.hs:14`:

```hs
-- before
solveD h = (2 ^ go h 2 0) * 2 - 1
  where go h cur l = if cur > h then l else go h (cur*2) (l+1)

-- after: an infinite sequence plus a stopping condition, as two separate ideas
solveD h = (2 ^ length (takeWhile (<= h) (iterate (*2) 2))) * 2 - 1
```

(Checked equal for `h = 1..20`.)

**Do not convert everything.** Keep hand-rolled recursion when you are not walking a list
(grid/tree/graph), when two or more accumulators travel together, or when the exit
condition depends on state a fold's `f` cannot see. Many of the 24 `go`s are legitimately
in that category.

Then do one problem that *requires* laziness — a prime sieve consumed by `takeWhile` —
so infinite structures become load-bearing rather than trivia.

---

## Phase 6: `Traversable` via the input layer

`IOUtils` is currently seven monomorphic `IO` functions with no `traverse`, `mapM` or
`forM` anywhere in `lib/`.

Rewrite it around:

```hs
readMany :: Read a => IO [a]
traverse  :: Applicative f => (a -> f b) -> [a] -> f [b]
replicateM :: Applicative m => Int -> m a -> m [a]
```

You meet Applicative in the one module every problem already touches. The payoff question
to answer for yourself: why is `traverse` more useful than `map` followed by `sequence`?

---

## Phase 7: `ST` and mutable arrays

Current state: zero `ST`, `IORef` or `State`.

Take a D problem that TLEs with immutable arrays and rewrite with `runST` + `STUArray`.

```hs
runST :: (forall s. ST s a) -> a
```

That `forall s.` is the interesting part: it is what stops a mutable array from escaping
the `runST` block, so a function full of mutation stays observably pure. There is no way
to understand it except by using it and then trying to break it — attempt to return the
array and read the error.

This is also the phase where the algorithm track and the type track finally meet: the
type system is buying you *performance* you cannot otherwise have.

---

## Phase 8 (optional): accept AtCoder's ceiling

> Beyond the model. Naoya's writing does not go here, so treat this as a separate ambition
> rather than the next rung. Phases 0–7 are the ones that close the measured gap.


Contests will never ask for GADTs, DataKinds, type families, rank-N types or monad
transformers. When those are the goal, the vehicle has to change.

The standard first project is a **typed expression interpreter**: a `data Expr a` indexed
by its result type, so `Add (IntLit 1) (BoolLit True)` fails to compile rather than
failing at runtime. Phantom types and GADTs become obvious in an afternoon.

At that point this repo has done its job and the learning moves elsewhere.

---

## Infrastructure: close the verification hole

`test/` holds `oj` sample files; `ac.cabal` has no `test-suite` stanza. On 2026-10-10 this
caused a real miss: `ABC156` was absent from `exposed-modules`, so `cabal build` reported
success while compiling none of the new code.

Add a `test-suite` with known-answer checks per module, so a module missing from
`exposed-modules` fails loudly.

Then use **QuickCheck**, which pays double here:

- writing `Arbitrary` instances is Phase 3 practice for free
- property tests suit the mathematical side of this hobby — *"my O(n) solution agrees with
  brute force on 10,000 random inputs"* is a stronger check than three samples

For the tooling itself — typed holes, `:sprint`, `Debug.Trace`, `+RTS -s`, differential
testing — see [`debugging-haskell.md`](debugging-haskell.md). Typed holes in particular
belong to this ramp: writing `_` and letting GHC tell you the required type is type-driven
development in its cheapest form.

That differential-test shape is exactly what caught the `ABC156-C` rounding bug: comparing
`solveC` against a brute-force minimum over all candidate meeting points, across every
sequence of length 1–5, found the floor-vs-round error that the official samples missed.

---

## Reading list (naoya.dev)

In the order most useful for this repo. Read one, then immediately re-solve a problem in
its style — reading without a re-solve does not stick.

| # | piece | why |
| - | ----- | --- |
| 1 | 操作から意味へ ─ Haskell が変えた私のメンタルモデル (2025-12-05) | the thesis; `map`/`fold` as meaning, binary search as boundary |
| 2 | 永続データプログラミングと競技プログラミング 〜 Haskell でがんばる競プロ (Zenn) | the contest method; ABC081-B, ABC311-A, ABC306-E, ABC322-D worked through |
| 3 | 永続データプログラミングと永続データ構造 (2024-12-03) | why keeping every snapshot is affordable |
| 4 | Haskell の Array (Zenn) | your 16 `Data.Array` files are the one area where you may already be ahead — check |
| 5 | TypeScript の Discriminated Union と Haskell の代数的データ型 (2024-12-13) | his one genuinely type-focused piece → feeds Phase 2 |
| 6 | 関数適用による状態遷移で DP を解く | DP as state transition by function application → the natural sequel to Phase 3.5 |
| 7 | Haskell の IntMap vs HashMap | performance intuition for the history idiom |
| 8 | Haskell はコードをフラットにする | why the style flattens nesting |

He also publishes per-contest retrospectives (ABC301 → ABC469). Reading his writeup of a
problem **after** solving it yourself is the highest-value habit available here — it is the
"read the editorial, close it, reimplement" loop from
[`haskell-algorithm-ramp.md`](haskell-algorithm-ramp.md), but aimed at *style* rather than
algorithm.

His rank progression, for calibration: 灰 → 茶 (ABC305) → 緑 (ABC317) → 水色 (ABC394,
2025-03-04) → 青 (ABC465). Years, not months.

---

## Checklist before moving a phase

Mirroring the algorithm ramp's checklist. You are ready to move on when you can answer
without looking:

- What does this type *forbid* that the previous version allowed?
- Which of my functions are total, and which are lying?
- Is this fold's operation associative, and what is its identity?
- Where does laziness change the answer rather than just the speed?
- Could the compiler have caught my last wrong answer? If not, why not?
- Did I transition state and compute the answer in the same pass? Could they be split?
- Am I reading this `map`/`fold` as meaning, or still simulating it as a loop?
