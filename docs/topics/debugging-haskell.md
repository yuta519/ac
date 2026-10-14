# Debugging Haskell

Everything here was run against this repo's toolchain (GHC 9.6.7) before being written
down. Numbers in the RTS section are real measurements, not illustrations.

## The mindset shift

In an imperative language, "debugging" mostly means **stepping through execution and
watching variables change**. In Haskell that is the *last* tool you reach for, not the
first — there are no variables changing, and evaluation order is not the order you wrote.

Instead, work down these layers and stop as soon as the bug is found. They are ordered by
cost: the top ones take seconds and need no running program at all.

| layer | tool | catches |
| ----- | ---- | ------- |
| 0 | the type checker, `-Wall`, **typed holes** | wrong shape, missing case, lying signature |
| 1 | GHCi `:t` `:i` `:sprint` | "what is this thing?", laziness questions |
| 2 | `Debug.Trace` | "was this evaluated, and with what?" |
| 3 | RTS stats `+RTS -s` | TLE, MLE, space leaks |
| 4 | differential testing vs. brute force | WA on a correct-looking algorithm |
| 5 | GHCi debugger `:break` `:step` | last resort, rarely needed |

Mapped onto the verdicts you actually get:

| verdict | first tool to reach for |
| ------- | ----------------------- |
| CE | the error message itself — read it top to bottom, fix the *first* one only |
| WA | differential test against brute force (layer 4) |
| TLE | `+RTS -s`, check complexity *and* strictness (layer 3) |
| MLE | `+RTS -s` maximum residency — usually a lazy-accumulator leak |
| RE | a partial function: `head`, `!!`, `read`, incomplete pattern |
| "I don't understand why" | `trace` (layer 2) or `:sprint` (layer 1) |

---

## Layer 0a: typed holes — the one to learn first

Write `_` where you don't know what to put. GHC will tell you the type it needs **and
suggest functions that fit**. Real output:

```hs
solveC :: [Int] -> Int
solveC xs = sum (map _ xs)
```

```
hole.hs:4:22: error: [GHC-88464]
    • Found hole: _ :: Int -> Int
    • In the first argument of ‘map’, namely ‘_’
    • Relevant bindings include
        xs :: [Int] (bound at hole.hs:4:8)
      Valid hole fits include
        negate :: forall a. Num a => a -> a
        fromIntegral :: forall a b. (Integral a, Num b) => a -> b
        id :: forall a. a -> a
        fromEnum :: forall a. Enum a => a -> Int
```

This is the single best tool in the language for the goal of *learning the type system*,
because it turns the compiler into a conversation. The workflow:

1. Write the type signature first.
2. Write `solveC xs = _`.
3. Compile. GHC says what the hole must be.
4. Fill in one layer — `sum _`, `sum (map _ xs)` — and compile again.
5. Repeat until there are no holes.

You are letting the types drive the code instead of guessing and checking. Several holes at
once is fine; name them (`_why`, `_acc`) to tell them apart in the output.

**Related: `undefined`.** It typechecks as *any* type, so it's a placeholder that lets the
rest of the module compile:

```hs
solveD :: Int -> [Int] -> Int
solveD = undefined   -- compiles; crashes only if actually called
```

Use it to stub a function you haven't written yet. Unlike `_`, it compiles cleanly — which
is also its danger.

## Layer 0b: make the compiler louder

In `ac.cabal`:

```
ghc-options: -Wall -Wincomplete-patterns -Wname-shadowing
```

`-Wincomplete-patterns` is the important one: it catches the missing case that becomes an
RE at judge time. `-Wname-shadowing` already has three hits in this repo
(`lib/ABC093.hs:12`, `lib/ABC125.hs:24`, `lib/ABC155.hs:20`).

**Reading a GHC error:** fix the **first** error and recompile. Later errors are often
cascade damage from the first and will vanish on their own. The three lines that matter are
`Found hole` / `Couldn't match type` (what went wrong), `In the expression` (where), and
`Relevant bindings` (what was in scope).

---

## Layer 1: GHCi as a workbench

```
ghci -ilib
:l ABC156          -- load a module
:r                 -- reload after editing
solveC [1,1,2,3]   -- just call it
```

That loop is faster than `cabal build` for exploring. Three commands worth knowing:

| command | what it does |
| ------- | ------------ |
| `:t e` | the type of `e` — use constantly |
| `:i Name` | *info*: a class's methods and every instance, or a type's constructors |
| `:sprint x` | show `x` **without forcing it** — see the thunks |

`:i` is how you learn the standard library. `:i Monoid` prints:

```
class Semigroup a => Monoid a where
  mempty :: a
  mappend :: a -> a -> a
  mconcat :: [a] -> a
instance Monoid [a]
instance Monoid Ordering
instance Semigroup a => Monoid (Maybe a)
instance (Monoid a, Monoid b) => Monoid (a, b)
...
```

— the methods you must define, plus every type that already has one.

### `:sprint` makes laziness visible

This is the companion to [`foldr-foldl-and-laziness.md`](foldr-foldl-and-laziness.md).
`:sprint` prints `_` for anything not yet evaluated. Real session:

```
ghci> let xs = map (*2) [1..10] :: [Int]
ghci> :sprint xs
xs = _                      -- nothing computed yet

ghci> print (head xs)
2
ghci> :sprint xs
xs = 2 : _                  -- only the first cell exists

ghci> print (sum (take 3 xs))
12
ghci> :sprint xs
xs = 2 : 4 : 6 : _           -- exactly as much as was demanded
```

The list grew only as far as something asked. `:sprint` on a `let`-bound expression before
and after `seq` shows the same thing for a plain value:

```
ghci> let n = 1 + 2 :: Int
ghci> :sprint n
n = _
ghci> seq n ()
()
ghci> :sprint n
n = 3
```

Use `:sprint` whenever you're unsure whether something is being evaluated. Note `:print`
and `:force` are siblings: `:force` evaluates then shows, `:sprint` never evaluates.

---

## Layer 2: `Debug.Trace`

`trace` is a normal function, not syntax:

```hs
import Debug.Trace (trace)

trace :: String -> a -> a
```

It returns its second argument unchanged and prints the message as a side effect, so
`trace msg x == x`. Wrapping an expression in `trace` never changes behaviour — it only
makes evaluation observable. Internally it uses `unsafePerformIO` to break purity, which is
why it's **debug-only** and must never stay in committed code.

### The family

| function | signature | use |
| -------- | --------- | --- |
| `trace` | `String -> a -> a` | a message you compose yourself |
| `traceShow` | `Show a => a -> b -> b` | dump any showable value, no `show` call needed |
| `traceShowId` | `Show a => a -> a` | **dump a value and return it** — wrap any subexpression |
| `traceM` | `Applicative f => String -> f ()` | inside a `do` block |
| `traceShowM` | `(Show a, Applicative f) => a -> f ()` | same, for a value |

`traceShowId` is the most convenient: drop it around any subexpression and you see that
value with no other edits.

```hs
solve :: [Int] -> Int
solve xs = sum (map f xs)
  where f x = traceShow ("f got", x) (x * 2)
```
```
("f got",1)
("f got",2)
("f got",3)
12
```

And inside `do`:

```hs
main = do
  traceM "step one"
  traceShowM ("n is", n)
```

### Three gotchas

1. **It prints to stderr**, which is unbuffered while stdout is buffered. Trace lines can
   appear *before* `putStrLn` output that logically preceded them. Don't read the
   interleaving as evaluation order. Use `./prog 2>/dev/null` to see only the real output,
   or `./prog 2>trace.log` to separate them.
2. **It fires once per thunk, not once per use** — `let s = trace "once" 7 in s + s`
   prints once and yields `14`. That's sharing, and it's informative in itself.
3. **A trace that never prints means the value was never forced.** That's a *result*, not
   a malfunction — frequently the answer to "why is my code not doing anything".

---

## Layer 3: `+RTS -s` for TLE and MLE

Compile with `-rtsopts`, then run with `+RTS -s` for a time and memory report. This is how
you tell "my algorithm is the wrong complexity" from "my algorithm is fine but lazy".

The classic Haskell performance bug, measured on `foldl` vs `foldl'` summing `[1..3000000]`
at `-O0`:

| | maximum residency | total memory |
| --- | --- | --- |
| `foldl'` (strict) | 44 KB | 6 MiB |
| `foldl` (lazy) | **177 MB** | **343 MiB** |

Same answer, same O(n) complexity, **4000× the memory**. Lazy `foldl` builds a chain of
three million unevaluated `+` thunks before collapsing any of them. That is a *space leak*,
and it is the usual cause of a Haskell MLE on a problem whose complexity is clearly fine.

> If memory is huge but your complexity is right, you have a laziness problem, not an
> algorithm problem. Look for a non-strict accumulator.

Fixes, in order of preference: use `foldl'` not `foldl`; use strict containers
(`Data.Map.Strict`, already used in `lib/ABC081.hs`); force with `seq` or a `!` bang
pattern on the accumulator.

Read `MUT time` for your actual computation and `GC time` for garbage collection — a large
GC fraction is another leak signature.

---

## Layer 4: differential testing for WA

**The most valuable technique in this repo**, because contest samples are too weak to catch
a subtly wrong formula. Write an obviously-correct brute force, then compare against your
clever solution over every small input.

This is exactly how the `ABC156-C` bug was found on 2026-10-10. `solveC` used
`sum xs \`div\` length xs` — the *floored* mean — and both official samples passed anyway.
The check:

```hs
bf ys = minimum [sum [(y-p)^2 | y <- ys] | p <- [1..100]]   -- obviously right, slow
seqs 0 = [[]]
seqs n = [v:r | v <- [1,2,3,4,99,100], r <- seqs (n-1)]

main = print [ (ys, solveC ys, bf ys) | n <- [1..5], ys <- seqs n, solveC ys /= bf ys ]
```

Empty list ⇒ agreement everywhere. Non-empty ⇒ it hands you the smallest counterexample.
The floored-mean bug showed up instantly on `[1,1,2,3]`: `5` instead of `3`.

Three rules that make this work:

- **Keep the value range tiny** (`[1,2,3,4,99,100]`, not `[1..100]`) and the length short
  (1–5). Bugs are nearly always at small sizes and at boundaries.
- **Include the extremes** of the constraints, not just small numbers.
- **The brute force must be dumb.** If it's clever it shares your bug.

Formalise this with QuickCheck once the `test-suite` exists — see
[`type-system-ramp.md`](type-system-ramp.md). The property is one line: *"my solution
equals brute force for all small inputs."*

Alongside it, keep using `oj` for the official samples (see `README.md`) — but treat
passing samples as the *start* of verification, not the end.

---

## Layer 5: the GHCi debugger (rarely needed)

It does exist and it works:

```
ghci> :break f          -- or :break brk.hs:5
ghci> main
Stopped in Main.f, brk.hs:5:10-14
ghci> :show bindings
_result :: Int = _
z :: Int = _
ghci> :step
Stopped in Main.f.z, brk.hs:4:15-19
ghci> :continue
49
```

Notice that the bindings show as `_` — they're **thunks**, not values, because at the
breakpoint nothing has forced them yet. Use `:force z` to evaluate and see one. This is
instructive about laziness but awkward for actual debugging, which is why it sits at the
bottom of this list: a `trace` or a `:sprint` usually answers the question faster.

Commands: `:break`, `:step`, `:steplocal`, `:continue`, `:show bindings`, `:force`,
`:delete`, `:trace` + `:history` (shows the last evaluation steps leading to an error).

---

## Setup checklist for this repo

- [ ] `ghc-options: -Wall -Wincomplete-patterns -Wname-shadowing` in both `ac.cabal` stanzas
- [ ] `-rtsopts` available for `+RTS -s` runs
- [ ] a `test-suite` stanza, so a module missing from `exposed-modules` fails loudly
      (`ABC156` was silently uncompiled until 2026-10-10)
- [ ] habit: `ghci -ilib` open in a second pane while solving

## Practice

Do these once each and the tools stop being theoretical:

1. Reintroduce the `div` bug in `lib/ABC156.hs` and find it with a differential test.
2. Take any solved problem, replace the body with `_`, and rebuild it from the hole types.
3. `:sprint` a `scanl` result (`lib/ABC154.hs:16`) at three stages of forcing.
4. Put `traceShowId` around a subexpression in a working solution; confirm the answer is
   unchanged and you can now see the intermediate value.
5. Write a `foldl` version of a sum over `[1..3000000]`, measure with `+RTS -s`, switch to
   `foldl'`, measure again.
