# Monads: the shape you're already using

This note is not a monad tutorial. It's the answer to a specific confusion: **`do` looks
like imperative mode, `>>=` looks like a magic symbol, and "monad" sounds like it must be
a big idea.** None of that is true, and this repo already contains the evidence.

Every example below is a real line from `lib/`, cited by file and line. Every snippet was
compiled and run before being written down.

---

## 1. The mental trap: `do` does not mean IO

Your own code, `lib/AdventOfCode2025Day1.hs:6-10`:

```hs
countZero :: [String] -> Int -> Int
countZero [] _ = 0
countZero (x : xs) current = do
  let next = mod (current + (translateRotateToInt x)) 100
  (if (next == 0) then 1 else 0) + (countZero xs next)
```

Read the type: `-> Int`. Not `IO Int`. There is no `IO` in this function at all — and yet
there is a `do`. And it compiles.

That should be surprising. If `do` meant "imperative block", this could not typecheck.

**Why it compiles:** `do` is *only* notation. It desugars into `>>=` calls — one per
statement boundary. This block has a `let` and then one final expression, so **zero** `>>=`
calls get generated. The `do` desugars to nothing:

```hs
countZero (x : xs) current =
  let next = mod (current + translateRotateToInt x) 100
   in (if next == 0 then 1 else 0) + countZero xs next
```

Both versions were run on the same input: both give `2`, and `==` on their results is
`True`. The `do` is doing literally nothing. It can be deleted.

> **`do` is notation for `>>=`. The monad is chosen by the *types*, not by the keyword.**

Write `getLine` in a `do` block and it's `IO`. Write a list and it's the list monad. Write
`Nothing` and it's `Maybe`. The keyword itself is agnostic.

This matters because the usual mental model — "`do` = escape hatch into imperative code" —
makes monads look like a special corner of the language where the rules change. They
aren't. It's one ordinary operator with nice syntax.

---

## 2. Deriving `>>=` yourself, in two lines

`>>=` is not special syntax. It's an ordinary function you could write yourself. Here is
the derivation, so it stops being a mystery symbol.

Say `readMaybe :: String -> Maybe Int` (it returns `Just 5` or `Nothing`). Parse three
tokens and sum them; any one can fail. Written by hand:

```hs
sumByHand s1 s2 s3 =
  case readMaybe s1 of
    Nothing -> Nothing
    Just a ->
      case readMaybe s2 of
        Nothing -> Nothing
        Just b ->
          case readMaybe s3 of
            Nothing -> Nothing
            Just c -> Just (a + b + c)
```

Three lines of real work (`readMaybe` ×3, then `a+b+c`) buried under **three identical
copies of the same block**:

```
Nothing -> Nothing         <- "if it failed, give up"
Just x  -> ...continue...  <- "if it worked, unwrap it and keep going"
```

Note you *cannot* escape this with a normal helper function. Step 2 must **not run at all**
if step 1 failed, and `a` from step 1 must still be in scope at step 3. That dependency is
what traps you in the nesting.

So make the repeated block a function. What does it need?

1. the `Maybe` value you already have → `Maybe a`
2. what to do next, given the unwrapped value → `a -> Maybe b`

```hs
andThen :: Maybe a -> (a -> Maybe b) -> Maybe b
andThen Nothing  _    = Nothing    -- it failed: give up, never run `next`
andThen (Just x) next = next x     -- it worked: unwrap x, hand it to `next`
```

**That is the entire thing.** Two lines. Now name it with symbols so it can sit *between*
its arguments (Haskell allows this for any operator):

```hs
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
Nothing  >>= _    = Nothing
(Just x) >>= next = next x
```

`a >>= f` is just `andThen a f`. Both versions were run: identical output.

**`>>=` is pronounced "bind" and reads as "and then".**

```hs
readMaybe s1 >>= \a -> ...rest...
```

*Parse s1; if it failed the whole thing is `Nothing` and `rest` never runs; if it worked,
call the unwrapped number `a` and continue into `rest`.*

The three forms are the same code:

```hs
-- by hand
case readMaybe s1 of { Nothing -> Nothing; Just a -> ... }

-- with >>=
readMaybe s1 >>= \a -> ...

-- with do
do a <- readMaybe s1
   ...
```

`\a -> ...` is a lambda — an unnamed function with parameter `a`. `\` is Haskell's
`lambda` / `=>`.

---

## 3. What "bookkeeping" means

Plain word, no jargon intended.

> **Bookkeeping is the code that repeats at every step and says nothing about *what* the
> step does.**

In `sumByHand` the problem was "add three numbers"; the bookkeeping was checking `Nothing`
and unwrapping `Just`, three times. In `lib/ATC001.hs:46-49` the problem is "search the
grid"; the bookkeeping is unwrapping the tuple and remembering to pass `v'` and not `v`.

A monad is where you put that code so you stop retyping it. Restating the one-liner less
abstractly:

> **A monad is a repetitive glue pattern between steps, factored out into `>>=` so you
> write only the steps.**

"What happens between two steps" = "what boilerplate got factored out."

---

## 4. Is it try/catch?

For `Maybe` and `Either` specifically, the resemblance is real:

```java
try {
    int a = parse(s1);
    int b = parse(s2);      // skipped if the line above throws
    int c = parse(s3);
    return a + b + c;
} catch (ParseException e) { return null; }
```

```hs
do a <- readMaybe s1
   b <- readMaybe s2       -- skipped if the line above is Nothing
   c <- readMaybe s3
   pure (a + b + c)
```

Same benefit: happy path in a straight line, failure jumps to the end. But three
differences matter, and **the third is the one that counts**:

1. **`Maybe` is in the type.** `:: ... -> Maybe Int` announces that it can fail. A Java
   method that throws looks identical to one that doesn't unless you read its `throws`
   clause or its body. The compiler forces you to handle `Nothing`; nothing forces you to
   catch an exception.

2. **No control-flow magic.** See §5.

3. **try/catch only does failure. `>>=` isn't about failure at all.** Failure is what
   *`Maybe`'s* `>>=` happens to do. Other monads carry completely different bookkeeping
   with no exception flavour: `[]` runs the rest once per element (a nested loop), `State`
   passes state along, `IO` keeps effects ordered. **try/catch is one monad's worth of
   behaviour.**

"And then" is a better mental verb than "catch."

### Aside: is errors-in-the-type a *functional programming* win?

Partly — but the credit mostly belongs elsewhere. **The real ingredient is a static type
system with sum types, not purity.** Rust has `Result`/`Option` with `?` and isn't
functional; Kotlin, Swift, and TypeScript get most of the way with non-nullable types and
unions.

What purity *does* contribute: in Haskell there is no alternative channel. A pure function
cannot throw, cannot return `null`, cannot set a global error flag — so if failure is
possible it *has* to be in the return type. In Java, `Optional<Integer>` is available but a
method can still throw or return `null`, so the type never tells the whole story. **Purity
is what makes the type exhaustive rather than merely available.**

The honest cost: `Maybe` is worse than exceptions when a failure should propagate untouched
through 15 layers. Exceptions skip the intermediate code for free; `Maybe` makes all 15
layers mention it. That's why Haskell also has real exceptions in `IO`. A tradeoff, not a
strict win.

Applied to this repo: `lib/ABC135.hs:3` is `solveA :: Int -> Int -> Maybe Int`, an honest
type — the answer genuinely doesn't exist when the parity is wrong. `Nothing` gives the
caller no *reason*, and on AtCoder that's correct: judges don't read reasons. Don't upgrade
it to `Either` thinking it's more rigorous; it's more ceremony for no gain.

---

## 5. Dominoes, not a trapdoor

The definition again:

```hs
myBind :: Maybe a -> (a -> Maybe b) -> Maybe b
myBind Nothing  _    = Nothing
myBind (Just x) next = next x
```

**No `throw`, no `catch`, no jump. Both branches just return a value.**

Watch a failure evaluate — this is substitution, each line the previous line simplified:

```
  myBind (readMaybe "oops") k
= myBind Nothing k              -- readMaybe returned a value: Nothing
= Nothing                       -- first equation matched; that's the answer
```

Three steps of ordinary function application. Nothing was thrown, because there is nothing
in `myBind` that *could* throw.

**Proof that step 2 never runs.** Pass in a continuation that crashes:

```hs
let boom _ = error "this line never runs"
myBind Nothing boom      -- => Nothing.  No crash.
```

`boom` was handed in as an argument and **never called** — the first equation ignores its
second argument (`_`). With try/catch the runtime must *enter* the code and then unwind out
of it. Here the code is never entered. The skip isn't an escape; it's an unused argument.

### Why "dominoes"

```
step1 >>= k1 >>= k2 >>= k3

  Nothing >>= k1   ->  Nothing      -- k1 never called
  Nothing >>= k2   ->  Nothing      -- k2 never called
  Nothing >>= k3   ->  Nothing      -- k3 never called
```

The `Nothing` is *handed forward* one link at a time. No link knows about the others; each
just applies the two-line rule. The result looks like a jump to the exit, but the mechanism
is local at every step.

The trapdoor, by contrast:

```
try {                     |  throw -> the runtime UNWINDS the stack,
  a = parse(s1);          |  discarding frames, skipping past
  b = parse(s2);          |  everything, landing in catch.
  c = parse(s3);          |  A non-local jump, built into the language.
} catch (e) { ... }       |
```

Three practical consequences:

- **You can reason locally.** An expression's value depends only on its parts — there's no
  "…and it might also secretly jump elsewhere" clause.
- **`>>=` is not privileged.** `myBind` above is hand-written and behaves exactly like the
  real one. You cannot hand-write `try`/`catch` in Java; it's a language feature.
- **It's why the abstraction generalises.** Because `>>=` is only "pass a value forward
  under a rule," the rule can be anything. A trapdoor can only ever do failure.

---

## 6. `Maybe` where it actually earns its keep

Parsing is the textbook example but a weak one. The real case is **chained lookups where
step 2 needs step 1's result**:

```hs
scores  = Map.fromList [("alice", 10), ("bob", 20)]
partner = Map.fromList [("alice", "bob")]

-- "find alice's partner, then that partner's score"
partnerScore :: String -> Maybe Int
partnerScore name =
  Map.lookup name partner >>= \p ->
    Map.lookup p scores
```

```
partnerScore "alice"  =>  Just 20     -- alice -> bob -> 20
partnerScore "bob"    =>  Nothing     -- bob has no partner
partnerScore "carol"  =>  Nothing     -- not in either map
```

`Map.lookup` returns `Maybe`, so this is unavoidable, and the second lookup is impossible
without the first's result. Both failure modes collapse into one `Nothing` for free.

### `traverse`: `>>=` over a whole list at once

Compare `lib/ABC042.hs:18` — `catMaybes $ map readMaybe xs`:

```hs
catMaybes (map readMaybe xs)  :: [Int]        -- silently DROPS bad tokens
traverse readMaybe xs         :: Maybe [Int]  -- all-or-nothing
```

```
traverse readMaybe ["1","2","3"]   =>  Just [1,2,3]
traverse readMaybe ["1","no","3"]  =>  Nothing
catMaybes (map readMaybe ["1","no","3"])  =>  [1,3]      <- note!
```

These differ in **meaning**, not in style. On AtCoder, where input is guaranteed
well-formed, `catMaybes` is a fine choice — no reason to change `ABC042`. The lesson is
being able to state the difference.

---

## 7. The list monad — already in this repo

`lib/ABC147.hs:14`:

```hs
combinations = replicateM (length xs) [True, False]
```

`replicateM 2 [True, False]` gives `[[True,True],[True,False],[False,True],[False,False]]`
— all 2^n boolean worlds. That is `>>=` chained *n* times. **A non-`IO` monad, already
doing real work in this repo.**

### It looks imperative. It isn't.

Written with the indentation ladder, the list monad mimics nested `for` loops
(ABC085-C Otoshidama shape):

```hs
otoshidama n y =
  [0 .. n] >>= \a ->
    [0 .. n - a] >>= \b ->
      let c = n - a - b
       in if 10000 * a + 5000 * b + 1000 * c == y then [(a, b, c)] else []
```

That layout is a teaching aid, and the "run the rest once per element" phrasing is loop
language. Both are misleading, because **`>>=` for lists is literally `concatMap`**:

```hs
xs >>= f  =  concatMap f xs
```

That's the definition in `base`. Verified: `[0..3] >>= \a -> [a, a*10]` equals
`concatMap (\a -> [a, a*10]) [0..3]`. Rewriting the above with `concatMap` and no `>>=` at
all gives identical results — same code, and now nothing looks imperative.

Three things follow that a `for` loop cannot do:

**1. The consumer decides how much runs.**

```hs
pythag =
  [1 ..] >>= \c ->
    [1 .. c] >>= \b ->
      [1 .. b] >>= \a ->
        if a * a + b * b == c * c then [(a, b, c)] else []

take 3 pythag   =>  [(3,4,5),(6,8,10),(5,12,13)]
```

The outer range is unbounded. It terminates because `take 3` stopped it **from outside**. A
`for` loop owns its own termination; here producer and consumer are decoupled. That's a
lazy stream, not a loop.

**2. It's a value.**

```hs
searchSpace = [1 .. 3] >>= \a -> [1 .. 3] >>= \b -> [(a, b)]
(length searchSpace, length (filter (uncurry (==)) searchSpace))   =>  (9, 3)
```

A first-class list, consumed twice in two different ways. A `for` loop is a statement — you
can't hand it to a function.

**3. Nothing mutates.** No accumulator, no index, no `results.append(...)`. Each
`\a -> ...` is a pure function from one element to a list of results; `concatMap` glues
them. `a` and `b` are *bindings*, not variables.

> The list monad expresses the same computation a nested loop expresses, without being one.
> It's a cartesian product built by function composition.

### Practical rule for this repo

**Prefer the comprehension.** It's the same code (verified with `==`), reads declaratively,
and doesn't invite the loop misreading:

```hs
[ (a, b, n - a - b)
| a <- [0 .. n]
, b <- [0 .. n - a]
, 10000 * a + 5000 * b + 1000 * (n - a - b) == y
]
```

Which also means every comprehension already in `lib/` (`ABC042.hs:30`, `ABC175.hs:15`) is
monadic code.

**So why learn the `>>=` form?** For `replicateM`. You cannot write
`replicateM n [True, False]` as a comprehension, because `n` isn't known at compile time so
you can't type out `n` generators. **Variable-depth enumeration is where the list monad
earns real keep** — exactly the Stage-2 exhaustive-search shape in
[[haskell-algorithm-ramp]].

---

## 8. `State` — closing the loop this repo left open

[[threading-state-through-recursion]] ends on the line "the `State` monad, which is
literally this threading, hidden behind `>>=`." Here is the cash-out.

`lib/ATC001.hs:46-49`:

```hs
go [] v = (False, v)
go (n : ns) v = case explore n v of
  (True, v') -> (True, v')
  (False, v') -> go ns v'
```

Structurally this is `sumByHand` again: a `case` whose only job is unwrap-and-pass-along.
The payload is a `visited` set instead of a `Just`, and nothing can fail — which is the
point. Look at the helper's type, `lib/ATC001.hs:32`:

```hs
explore :: (Int, Int) -> Set.Set (Int, Int) -> (Bool, Set.Set (Int, Int))
--                       ^^^ state in                    ^^^ state out
```

Strip the problem-specific parts and that's `s -> (a, s)`. **That is the definition of
`State s a`.** Same search, with the threading delegated:

```hs
explore :: (Int, Int) -> State (Set (Int, Int)) Bool
explore (x, y)
  | not (inBounds (x, y)) = pure False
  | c == '#' = pure False
  | otherwise = do
      seen <- gets (Set.member (x, y))
      if seen
        then pure False
        else
          if c == 'g'
            then pure True
            else do
              modify (Set.insert (x, y))
              anyM explore [(x + dx, y + dy) | (dx, dy) <- dirs]
  where
    c = cells ! (x, y)

-- short-circuiting monadic `any`: stops at the first True, and the state
-- carried so far survives into the next sibling either way
anyM :: (Monad m) => (a -> m Bool) -> [a] -> m Bool
anyM _ [] = pure False
anyM f (a : as) = do
  found <- f a
  if found then pure True else anyM f as
```

Run with `evalState (explore start) Set.empty`. Verified against the ATC001-A samples:
`True` on the reachable grid, `False` on the blocked one.

`>>=` for `State` *is* the `v'` threading — mechanically, the line
[[threading-state-through-recursion]] calls "the whole fix." `modify` is the `Set.insert`;
`gets` is the `Set.member` check.

### The honest verdict: the explicit version is better here

For ATC001-A, keep `lib/ATC001.hs` as it is. Reasons:

- The `visited` threading **is the lesson** of that problem. Hiding it behind `>>=` hides
  the thing worth seeing.
- Short-circuit-on-success is visible in the explicit fold; in the monadic version it needs
  a hand-written `anyM`, and doing it "properly" drags in `StateT`/`ExceptT`.
- One piece of state, one recursion. Nothing to gain.

`State` earns its keep with **several** pieces of state, or long straight-line runs of
updates. Recognising the shape is the goal; rewriting is not. Your own instinct applies
here: when monadic code starts reading like statements, that's often a signal the monad
isn't buying anything and a plain HOF (`concatMap`, `traverse`, `foldl'`) says it better.

**Build caveat:** `Control.Monad.State` lives in `mtl`, which ships with GHC (verified:
`mtl-2.3.1` in the package db), so `runghc -ilib app/Main.hs` works. But `ac.cabal`'s
library stanza declares only `array, containers, base` — a `lib/` module using `State`
needs `mtl` added to `build-depends` before `cabal build` will work.

---

## 9. `ST` — the escape hatch for when `Set` TLEs

Not a general tool. It's the answer to one specific failure, the one
[[threading-state-through-recursion]] predicts: "`Set` + `!!` TLEs (it will around #4 /
AGC033-A)."

`lib/ATC001.hs:23-26` already made half the fix — `Data.Array` for O(1) grid reads instead
of `grid !! x !! y`. The other half is a **mutable unboxed array** for `visited`: O(1)
marking, no log factor, and no set to thread at all.

```hs
maxDist :: Int -> Int -> UArray (Int, Int) Char -> Int
maxDist h w cells = runST $ do
  dist <- newArray ((0, 0), (h - 1, w - 1)) (-1) :: ST s (STUArray s (Int, Int) Int)
  let sources = [(x, y) | x <- [0 .. h - 1], y <- [0 .. w - 1], cells ! (x, y) == '#']
  forM_ sources $ \p -> writeArray dist p 0
  go dist sources 0
  where
    go _ [] acc = pure acc
    go dist frontier acc = do
      next <- concat <$> mapM (step dist) frontier
      if null next then pure acc else go dist next (acc + 1)
    -- step/visit: readArray to test, writeArray to mark; full version in the
    -- multi-source BFS for AGC033-A
```

Verified: compiles `-Wall` clean and returns `3` on a 4x4 test grid.

**The part that makes `ST` worth understanding** is its escape hatch's type:

```hs
runST :: (forall s. ST s a) -> a
```

That `forall s.` makes mutation **unable to leak**. A mutable array tagged with `s` cannot
escape the `runST` block, so from the outside an `ST` block is an ordinary pure function.
Reaching for `ST` is not giving up on purity — it's local mutation with a compiler-enforced
fence.

**No build change needed:** `Data.Array.ST` comes from `array`, already in `ac.cabal`'s
`build-depends`. (Contrast with `State`, above.)

---

## 10. `Either` — with the caveat first

**`Either` barely earns its place on AtCoder.** Judges don't read error messages and input
is well-formed. It's here for completeness, and because it's everywhere in production
Haskell.

`Either e a` is `Maybe` with a reason attached — `Left e` short-circuits exactly like
`Nothing`, but carries `e` along:

```hs
readMaybe :: String -> Maybe Int              -- Nothing: "it failed"
parseInt  :: String -> Either String Int      -- Left "bad token: xyz": "it failed BECAUSE"
```

Same `>>=` shape, same dominoes. That's all.

---

## 11. Not a closed set

Those six aren't "the monads." `Monad` is a **typeclass** — an interface — so anything can
implement it. `:info Monad` in this project's GHC, with `mtl` and `ST` loaded, reports:

```
Monad IO            Monad Maybe          Monad (Either e)     Monad []
Monad (ST s)        Monad (StateT s m)   Monad Identity       Monad Solo
Monad ((->) r)                 <- functions are a monad (Reader)
Monoid a => Monad ((,) a)      <- pairs are a monad (Writer)
```

And that's only what happened to be imported.

**The more useful fact is what is *not* a monad**, because it shows the concept has content:

- **`Data.Set`** — not even a `Functor`. `fmap` would need an `Ord` constraint on the result
  type and the class doesn't permit that.
- **`Data.Map k`** — a `Functor` and `Traversable`, but *not* a `Monad`.
- **`ZipList`** — an `Applicative` but deliberately not a `Monad`; no lawful `>>=` exists
  for zip semantics.

That last one is the key: **`Monad` adds exactly one power over `Applicative` — the next
step may depend on the previous step's value.** `ZipList` can combine independent effects
but can't do that, so it stops at `Applicative`.

The whole definition: a type `m` is a monad if you can write `return :: a -> m a` and
`(>>=) :: m a -> (a -> m b) -> m b` obeying three laws. Nothing more.

---

## The pattern, named

> **A monad is a rule for what happens between two steps.** `do` writes the steps; the type
> decides the rule.

The one signature to memorise, and the reason a single abstraction covers error handling
*and* nested loops:

```hs
(>>=) :: m a -> (a -> m b) -> m b

Maybe:  Maybe a -> (a -> Maybe b) -> Maybe b     -- skip the rest on Nothing
[]:     [a]     -> (a -> [b])     -> [b]         -- run the rest per element
IO:     IO a    -> (a -> IO b)    -> IO b        -- keep effects in order
State:  the state hands forward along the arrow
ST:     mutate in place, fenced by runST
```

Same skeleton; only the joins differ.

### Recognition triggers — when to reach for one

| what you're writing | reach for |
| --- | --- |
| repeated `case x of Nothing -> Nothing; Just y -> ...` | `Maybe` / `>>=` |
| "try every combination", depth known at compile time | a list comprehension |
| "try every combination", depth is a runtime value | `replicateM` (list monad) |
| a recursive helper whose type ends `-> s -> (a, s)` | that's `State` — *recognise* it; rewriting is optional |
| a threaded `Set`/`Map` that TLEs | `ST` + `STUArray` |
| an error that needs a *reason* attached | `Either` (rarely, on AtCoder) |

---

## Practice ladder

Problems reused from [[haskell-algorithm-ramp]] so this slots into the existing plan.

| # | task | link | what it proves |
| - | ---- | ---- | -------------- |
| 1 | Delete the `do` from `lib/AdventOfCode2025Day1.hs:8`, confirm it still compiles | — | §1: `do` was doing nothing |
| 2 | ABC085-C: Otoshidama — solve with a comprehension, then again with `>>=` | https://atcoder.jp/contests/abc085/tasks/abc085_c | §7: they're the same code |
| 3 | ABC087-B: Coins | https://atcoder.jp/contests/abc087/tasks/abc087_b | §7: `replicateM`-style enumeration |
| 4 | `redo atc001-a`, re-solve with `State` instead of the explicit fold | https://atcoder.jp/contests/atc001/tasks/dfs_a | §8: then judge which reads better — this note predicts the explicit one wins |
| 5 | AGC033-A: Darker and Darker — multi-source BFS in `ST` | https://atcoder.jp/contests/agc033/tasks/agc033_a | §9: the problem where `Set` actually TLEs |

Step 4 uses Workflow B from [`../workflows.md`](../workflows.md); `pre/atc001-a` exists, so
`redo atc001-a` works as-is. Compare afterwards with
`git diff main attempt/01-atc001-a -- lib/ATC001.hs`.

### Self-check

Answerable without looking:

- What is the type of `>>=`? What do `m`, `a`, and `b` stand for in the monad I'm using?
- What happens *between* two steps of my `do` block?
- Which monad is a list comprehension? Which function is its `>>=`?
- My recursive helper's type ends `-> s -> (a, s)`. Which monad is that?
- What stops `ST`'s mutation from escaping `runST`?
- Is `Data.Set` a monad? Why not?
- Am I using a monad because it deletes bookkeeping, or because it's ceremony?

---

Related: [[threading-state-through-recursion]] for the `visited`-threading problem §8 grows
out of, and [[haskell-algorithm-ramp]] for the general practice loop.
