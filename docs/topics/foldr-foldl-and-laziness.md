# `foldr`, `foldl'`, and why laziness is the whole point

This note answers one confusion: **why can `foldr` walk an infinite list and stop early,
while `foldl'` cannot?** Every snippet below was compiled and run before being written
down.

Current repo state: `foldl'` in 10 files, `foldr` in **0**, a hand-written `go` helper in
24. So this is the gap, not a refinement.

---

## 1. A fold is recursion someone already named

Both folds are just the two ways to collapse a list. Nothing magic:

```hs
foldl' f z [a,b,c]  ==  ((z `f` a) `f` b) `f` c     -- accumulate left, strict
foldr  f z [a,b,c]  ==  a `f` (b `f` (c `f` z))     -- nest to the right, lazy
```

Look at where the parentheses are. That is the entire difference, and everything else
follows from it.

- `foldl'` must reach the **end** of the list before the outermost `f` can run, because
  the outermost call is the *last* element. No end, no answer.
- `foldr`'s outermost `f` is applied to the **first** element immediately. Its second
  argument is the folded rest — and `f` may choose never to look at it.

That last sentence is the whole trick.

---

## 2. The mechanism, traced

```hs
step :: Int -> Bool -> Bool
step x acc = trace ("visiting " ++ show x) (x > 100 || acc)

foldr step False [1..]
```

(`trace :: String -> a -> a` returns its second argument untouched and prints the message
as a side effect, so `step` is just `x > 100 || acc`. It's a window, not part of the
mechanism — see [`debugging-haskell.md`](debugging-haskell.md).)

Expand it by hand. `foldr` applies `step` to the head and *a promise* of the rest:

```
foldr step False [1..]
  = step 1 (foldr step False [2..])
  = 1 > 100 || (foldr step False [2..])
       ^^^^^^^^^   ^^^^^^^^^^^^^^^^^^^^^^
       False       never evaluated yet
```

`||` is lazy in its right argument: `False || y` has to look at `y`, but `True || y`
returns `True` without touching `y`. So:

- `x = 1`   → `1 > 100` is `False` → must evaluate the rest → recurse
- `x = 2`   → same → recurse
- …
- `x = 101` → `101 > 100` is `True` → `||` **returns immediately**, the pending
  `foldr step False [102..]` is thrown away unevaluated

Actual output, counted: **exactly 101 `visiting` lines, then `True`.** The list `[1..]` is
infinite; we touched 101 elements of it and stopped.

The promise that never gets forced is called a *thunk*. `foldr`'s laziness means the tail
of the fold is always a thunk, so whether the recursion continues is decided by `f`, one
element at a time.

### Why `foldl'` can't do this

```hs
foldl' step False [1..]   -- runs forever
```

`foldl'` is strict and left-nested: it must compute `((False `step` 1) `step` 2) `step` 3…`
and the outermost application needs the *final* element. There is no final element. Even
though `step` would short-circuit, `foldl'` never gets to a position where
short-circuiting would help. It just keeps consuming.

### `foldr` is not magic either — it depends on `f`

```hs
foldr (+) 0 [1..]   -- also runs forever
```

`+` **forces both** arguments. So the thunk gets evaluated, which recurses, which makes
another thunk, forever. `foldr` on an infinite list terminates only when `f` can ignore
its second argument.

> **`foldr` short-circuits iff `f` is lazy in its second argument.**
> `||`, `&&`, `:` qualify. `+`, `max`, `min` do not.

---

## 3. Changing `b`: getting a number instead of a yes/no

`b` was `Bool` only because the question was yes/no. It is whatever you want back. Same
fold, same laziness, different `b`:

```hs
-- "is there one over 100?"          b = Bool
foldr (\x rest -> x > 100 || rest)              False   [1..]  -- True

-- "which is the first over 100?"    b = Maybe Int
foldr (\x rest -> if x > 100 then Just x else rest) Nothing [1..]  -- Just 101
```

As a named function rather than a lambda:

```hs
func :: Int -> Maybe Int -> Maybe Int      -- NOT Int -> Int -> Int
func x rest = if x > 100 then Just x else rest

foldr func Nothing [1..]   -- Just 101
```

The signature is the easy thing to get wrong. Three constraints force it:

1. `Just x :: Maybe Int`, not `Int` — `Just` is a constructor, it changes the type.
2. Both branches of an `if` must have the same type, so `rest :: Maybe Int`.
3. So the result is `Maybe Int`.

Writing `Int -> Int -> Int` gets you:

```
Couldn't match expected type ‘Int’ with actual type ‘Maybe Int’
  In the expression: Just x
```

Lining it up with `foldr`'s type makes it obvious:

```
foldr :: (a -> b -> b) -> b    -> [a]  -> b
func  ::  Int -> Maybe Int -> Maybe Int
          └a┘   └───b───┘     └───b───┘
foldr func Nothing [1..]
            └─b─┘   └[a]┘
```

> **In a `foldr`, `rest`, the base case, and the final answer are all type `b`.** Decide what
> you want back and all three positions are determined. When the compiler complains, ask
> "what is my `b`?" and check that all three agree.

### Short-circuiting is a property of the question, not the fold

```hs
-- first over 100: the `then` branch ignores `rest`, so it stops
firstBig = foldr (\x rest -> if x > 100 then Just x else rest) Nothing

-- how many over 100: `+` always forces `rest`, so it cannot stop
countBig = foldr (\x rest -> (if x > 100 then 1 else 0) + rest) 0
```

| | `[1..200]` | `[1,2,3]` | `[1..]` |
| --- | --- | --- | --- |
| `firstBig` | `Just 101` | `Nothing` | **`Just 101`** |
| `countBig` | `100` | `0` | **hangs** |

"How many are over 100?" *cannot* be answered without seeing every element. No choice of
fold fixes that. "Is there one?" and "which is the first?" can.

| your question | `b` | reach for |
| ------------- | --- | --------- |
| is there one? | `Bool` | `any` |
| which is the first? | `Maybe a` | `find` |
| where is the first? | `Maybe Int` | `findIndex` |
| how many / total / largest? | `Int` | **`foldl'`** |

Note `firstBig` returns `Maybe Int`, not `Int` — `[1,2,3]` has no element over 100, so
there is no number to return. That is `Maybe` arising from the problem rather than as an
exercise; see Phase 4 of [`type-system-ramp.md`](type-system-ramp.md).

---

## 4. You are already using `foldr` without knowing it

`lib/ABC155.hs:14`:

```hs
solveB as = if not violation then "APPROVED" else "DENIED"
  where violation = any (\x -> even x && x `mod` 3 /= 0 && x `mod` 5 /= 0) as
```

`any` **is** `foldr` with `||`. It stops at the first match instead of scanning the rest.
Same for `or`, `and`, `all`, `find`, `takeWhile`, `concatMap`, and `map` itself. Every one
is `foldr`-shaped, which is why they all work on infinite lists.

So the instinct is already there. What's missing is writing the pattern yourself when no
pre-made combinator happens to fit.

---

## 5. Decision table

| Need | Reach for |
| ---- | --------- |
| Collapse a finite list into one summary value | `foldl'` |
| Sum, count, max, min, running total | `foldl'` |
| Does any/every element satisfy …? | `any` / `all` (= `foldr`) |
| First element / index satisfying … | `find` / `findIndex` (= `foldr`) |
| Stop as soon as a condition flips | `foldr`, or `takeWhile` |
| Consume an unbounded / generated sequence | `foldr`, `takeWhile`, `iterate` |
| Build a list from a list | `map`, `filter`, or `foldr (:)` |
| Build a list from a seed | `unfoldr`, `iterate` |
| Keep every intermediate state | `scanl` |
| Not walking a list at all (grid, tree, graph) | **keep your `go`** |
| Two or more accumulators travelling together | **keep your `go`** |

The last two rows matter. Do not convert everything — many of the 24 `go` helpers are
legitimately hand-rolled recursion over non-list structure. Converting those would be
cargo-culting.

---

## 6. Two rewrites from this repo

### `lib/ABC156.hs:7` — `go` over a numeric sequence

```hs
-- before
solveB n k = go 1
  where go cur = if n >= k ^ cur then go (cur + 1) else cur

-- after
solveB n k = length $ takeWhile (<= n) $ iterate (* k) 1
```

`iterate (* k) 1` is the **infinite** list `[1, k, k², k³, …]`. `takeWhile` decides where it
ends. Two separate ideas — "the sequence" and "the stopping rule" — instead of one loop
that tangles them. (Checked equal for all `n = 1..300`, `k = 2..10`.)

### `lib/ABC153.hs:14` — same shape

```hs
-- before
solveD h = (2 ^ go h 2 0) * 2 - 1
  where go h cur l = if cur > h then l else go h (cur*2) (l+1)

-- after
solveD h = (2 ^ length (takeWhile (<= h) (iterate (*2) 2))) * 2 - 1
```

(Checked equal for `h = 1..20`.)

---

## 7. Practice ladder

Ordered. Re-solves come first because the comparison is the lesson — keep the old version
in the file as `solveB'` so you can diff the two readings.

### Stage A — convert your own `go`s

| # | file | task |
| - | ---- | ---- |
| 1 | `lib/ABC156.hs` `solveB` | `go` → `iterate` + `takeWhile`, as above |
| 2 | `lib/ABC153.hs` `solveD` | same shape, do it without looking at the answer |
| 3 | `lib/ABC081.hs` `count2power` | recursion over halving — express as a stream |
| 4 | `lib/ABC093.hs`, `lib/ABC125.hs` | the two shadowed `min`s; rename *and* refold |

### Stage B — `foldl'` as the accumulator

| # | problem | focus |
| - | ------- | ----- |
| 1 | ABC088-B: Card Game for Two | sort desc, fold with an alternating-turn accumulator |
| 2 | ABC083-B: Some Sums | `filter` then `foldl'` — notice you need no recursion at all |
| 3 | ABC085-B: Kagami Mochi | fold into a `Set`; the accumulator is a structure, not a number |

The question to answer each time: *what is the accumulator, and what is its identity
value?*

### Stage C — `foldr` and short-circuiting

| # | problem | focus |
| - | ------- | ----- |
| 1 | ABC155-B | you already solved it with `any` — now write that `any` as an explicit `foldr` and confirm identical results |
| 2 | ABC049-C: Daydream | consume a string from one end, failing early — `foldr`-shaped |
| 3 | prime sieve + `takeWhile` | the canonical "laziness is load-bearing" exercise: define *all* primes, take what you need |

### Stage D — `scanl` and the history idiom

`scanl` is already in 8 of your files (e.g. `lib/ABC154.hs:16`), so this is the one you
have a head start on. Push it further:

| # | problem | focus |
| - | ------- | ----- |
| 1 | ABC037-C: 総和 | prefix sums via `scanl` rather than index arithmetic |
| 2 | ABC311-A | `scanl` the inserts into a `Set`, then `elemIndex` the target state |
| 3 | ABC081-B | `iterate` the whole array, then `findIndex (any odd)` |

That last one is worth doing even though `lib/ABC081.hs` already has an accepted answer —
see [`type-system-ramp.md`](type-system-ramp.md) on 操作 vs 意味, where the two versions
are compared directly. `findIndex` and `elemIndex` currently appear in **zero** files;
they are the search half of this idiom.

---

## 8. Self-check

- Why does `foldr (||) False [1..]` terminate but `foldr (+) 0 [1..]` not?
- Which argument of `f` must be lazy, and why the second rather than the first?
- `foldl'` has a `'`. What would plain `foldl` do differently on `[1..10^7]`?
- Name three Prelude functions that are secretly `foldr`.
- If `rest` is a `Maybe Int`, what must the base case and the final answer be?
- Why can "which is the first element over 100?" short-circuit when "how many are over
  100?" cannot?
- For one of your own `go` helpers: is it over a list? If not, why is a fold the wrong tool?
