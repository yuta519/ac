# ABC147-C — How to think about this problem

Problem: https://atcoder.jp/contests/abc147/tasks/abc147_c

This walks through *how to arrive at the solution*, and ends with the accepted Haskell
implementation. The underlying logic genre (knights and knaves, the "gate" model) is
covered separately in
[`../topics/knights-and-knaves-consistency.md`](../topics/knights-and-knaves-consistency.md)
— read that first; this note is about turning it into code.

## 1. Read the constraints first

- **1 ≤ N ≤ 15**
- `0 ≤ A_i ≤ N-1` testimonies per person, targets distinct, `y ∈ {0,1}`.
- Time limit 2 s.

N ≤ 15 is *absurdly* small compared to the array problems (1e5, 1e12). That is the whole
hint: **2¹⁵ = 32768** possible honest/unkind assignments. Enumerating every one is free.

Whenever N ≤ ~20 and the answer is a subset/assignment, read it as **permission to
brute-force all 2^N configurations**. Pin that down before designing anything — it saves
you from inventing a clever deduction that isn't needed.

## 2. Reframe the problem in your own words

Each person is honest or unkind. Honest people's testimonies are **all true**; unkind
people's testimonies carry **no information** (they may lie or not, freely). Maximise the
number of honest people over all self-consistent assignments.

Naive framing: "start from person 1, assume they're honest, follow their claims to deduce
others' statuses, recurse." **This does not work** — see §3.

The reframe — the key move:

> Don't *derive* the labels. **Propose a complete labelling, then verify it.** A labelling
> is consistent iff every person labelled honest made only claims that match that same
> labelling. With N ≤ 15 you can propose all 2^N of them.

## 3. Why propose-and-verify, not propagation/recursion

The tempting approach is to walk the testimony graph deducing statuses. Three reasons it
fails:

1. **No starting point.** "Assume person 1 is honest" is a *hypothesis*, not a deduction.
   Nothing in the input tells you anyone's status.
2. **The skip rule needs the answer first.** Whether to follow person B's claims depends
   on B's status — which is exactly what you were trying to derive. Circular.
3. **Unreached people are still unconstrained but still need labels.** If nobody mentions
   person C, a traversal never labels them, yet C's own claims can create contradictions
   once C is labelled honest.

There's also a **within-speaker** subtlety worth stating: an honest person's *every*
testimony binds — including the "is unkind" ones. Following only the "is honest" claims
(a natural first instinct) silently misses contradictions. Example:

```
A says "B is unkind";  B says "C is honest";  C says nothing
```

Following only honest-claims from A finds nothing, so all-honest looks fine — but A is
honest and asserted B is unkind, contradicting B=H. Real max is 2 (A=H, B=U, C=H), not 3.

So: verification, not propagation. Given a *complete* labelling the check is purely
**local** — read labels, compare to claims, no deduction or ordering needed.

## 4. Concrete algorithm

```
for each of the 2^N labellings w:            -- replicateM n [True, False]
    consistent = True
    for each person i with w[i] == honest:   -- the GATE: skip unkind speakers
        for each testimony (x, y) by person i:
            claim   = (y == 1)               -- y=1 "x is honest", y=0 "x is unkind"
            reality = w[x - 1]               -- 1-indexed input, 0-indexed list
            if reality /= claim: consistent = False
    if consistent: record (number of honest in w)
answer = max recorded
```

Invariant: a labelling is recorded iff no honest speaker's claim disagrees with that same
labelling. `maximum` is always safe because **all-unkind is always consistent** (every
gate closed, nothing to check) — so the candidate list is never empty and no "impossible"
case exists.

### Worked example: sample 3 (`answer 1`)

```
Person 1: "2 is unkind"   (2,0)
Person 2: "1 is unkind"   (1,0)
```

```
w = [T,F]  (1=H, 2=U):
  person 1 is H → gate OPEN  → claim (2,0): claim=False, reality=w[1]=False  ✓ holds
  person 2 is U → gate CLOSED → skip
  ⇒ consistent, 1 honest   ← the answer

w = [T,T]: person 1 honest claims 2 unkind, but w[1]=True         ✗
w = [F,T]: person 2 honest claims 1 unkind — holds; but see below  ✓ 1 honest
w = [F,F]: both gates closed                                       ✓ 0 honest
```

The non-obvious moment: a **truthful "is unkind" claim must be accepted**. That's what
`reality == claim` gets right and what a naive `reality && claim` gets wrong (§ Bug below).

### Visual walkthrough of `consistent` (sample 1)

Building the check one stage at a time, on real values.

```
xs = [[(2,1)], [(1,1)], [(2,0)]]

   Person 1:  "2 is honest"     (2,1)
   Person 2:  "1 is honest"     (1,1)
   Person 3:  "2 is unkind"     (2,0)
```

Test the world `w = [True, True, False]`:

```
        index:    0      1      2
        w    = [ True, True, False ]
        person:   1      2      3
                  H      H      U
```

> ⚠️ Person `n` lives at index `n-1`. Input is 1-indexed, lists are 0-indexed.

**Step 1 — `zip w xs`: pair each label with that person's testimonies.**

```
   ┌────────┬─────────────┐
   │ label  │ testimonies │
   ├────────┼─────────────┤
   │ True   │ [(2,1)]     │  ← person 1 is H, said "2 is honest"
   │ True   │ [(1,1)]     │  ← person 2 is H, said "1 is honest"
   │ False  │ [(2,0)]     │  ← person 3 is U, said "2 is unkind"
   └────────┴─────────────┘
```

Each row now holds both things the check needs: *is this speaker honest?* and *what did
they say?*

**Step 2 — `, isHonest`: apply the GATE.**

```
   │ True   │ [(2,1)]  │  ──▶ gate OPEN   ✓ keep, must check
   │ True   │ [(1,1)]  │  ──▶ gate OPEN   ✓ keep, must check
   │ False  │ [(2,0)]  │  ──▶ gate CLOSED ╳ discard entirely
```

A bare `Bool` in a comprehension filters — that *is* the gate.

**Step 3 — `, (x, y) <- sts`: flatten to individual testimonies.**

An honest person may have several, and **all** bind:

```
   from person 1:  (x=2, y=1)     "person 2 is honest"
   from person 2:  (x=1, y=1)     "person 1 is honest"

   (person 3's testimony never appears — gate was closed)
```

**Step 4 — check one testimony against the world.**

```
   ┌──────────────────────────────────────────────────┐
   │  y = 1  ⟹  "person x is HONEST"  ⟹  want True   │
   │  y = 0  ⟹  "person x is UNKIND"  ⟹  want False  │
   └──────────────────────────────────────────────────┘
            so the CLAIM is:  (y == 1)

   ┌──────────────────────────────────────────────────┐
   │  what the world SAYS about person x:             │
   │       w !! (x - 1)                               │
   └──────────────────────────────────────────────────┘

   testimony holds  ⟺   w !! (x-1)  ==  (y == 1)
                        └────┬────┘      └───┬──┘
                          reality          claim
```

**Step 5 — `and [...]`: every check must pass.**

Two contrasting worlds, traced as `(x, y, reality, claim, holds?)`:

```
world [True,True,False]  (1=H 2=H 3=U)
    (2, 1, True,  True,  True )
    (1, 1, True,  True,  True )
  ⇒ and [...] = True    ✓ CONSISTENT — 2 honest   ← sample 1's answer

world [True,False,True]  (1=H 2=U 3=H)
    (2, 1, False, True,  False)   ← person 1 claimed 2 is honest; world says U
    (2, 0, False, False, True )   ← person 3's claim happens to hold
  ⇒ and [...] = False   ✗ INCONSISTENT
```

In the second world person 3's gate *is* open (3=H) so their testimony is checked too —
but one failure is enough for `and` to reject.

**The pipeline as a whole:**

```
   xs, w
     │
     ▼
  ┌──────────────────────────────────────┐
  │ zip w xs      pair label+testimonies │  step 1
  └──────────────────────────────────────┘
     │
     ▼
  ┌──────────────────────────────────────┐
  │ , isHonest    GATE — drop unkind     │  step 2
  └──────────────────────────────────────┘
     │
     ▼
  ┌──────────────────────────────────────┐
  │ , (x,y) <- sts   flatten testimonies │  step 3
  └──────────────────────────────────────┘
     │
     ▼
  ┌──────────────────────────────────────┐
  │ w !! (x-1) == (y == 1)               │  step 4
  │  reality        claim                │
  └──────────────────────────────────────┘
     │
     ▼
  ┌──────────────────────────────────────┐
  │ and [...]     all must hold          │  step 5
  └──────────────────────────────────────┘
     │
     ▼
   True / False
```

Then `solveC` wraps this: loop over all 2^N worlds, keep the consistent ones, take the
maximum honest count.

## 5. Check the complexity

- Worlds: 2^N ≤ 32768.
- Per world: ≤ N people × ≤ N-1 testimonies, each doing an O(N) list `!!`.
- Total: ~32768 × 15 × 14 × 15 ≈ 1e8 worst-case elementary steps, but the `and` guard
  short-circuits on the first failure so real cost is far lower.

Measured: worst case (N=15, every person testifying about all 14 others) runs in
**0.056 s**. Well inside 2 s.

Note `!!` is O(index) — normally a TLE trap (see ABC139-C) — but at N ≤ 15 it's
irrelevant. No need for `Data.Array` here; know *when* the rule matters.

## 6. Spot-check the answer's range

Answer is at most N = 15. Trivially fits `Int`. No overflow concerns anywhere.

## The bug worth remembering: `&&` vs `==`

First attempt at the per-testimony check:

```haskell
c !! (x - 1) && y == 1        -- WRONG
c !! (x - 1) == (y == 1)      -- correct
```

`&&` demands "person x is honest **and** the claim was 'honest'", so it can never verify a
`y == 0` testimony. Truth table for a `y=0` claim ("x is unkind"):

| reality `c!!(x-1)` | y | `&&` version | `==` version | should be |
|---|---|---|---|---|
| False (x is U) | 0 | `False && False` = **False** ❌ | `False == False` = **True** | True — truthful claim! |
| True (x is H) | 0 | False ✓ | `True == False` = False ✓ | False |

Row 1 is the defect: an honest person truthfully saying "x is unkind" was rejected. It
passed samples 1 and 2 but returned **0 instead of 1** on sample 3 — a reminder that
sample 2's answer being `0` makes it useless as a regression signal here.

The mental model that prevents it: you are comparing **reality against claim** — they must
*match*, regardless of which way the claim points.

```
reality = c !! (x - 1)     -- what this world says about person x
claim   = (y == 1)         -- what the speaker asserted
holds   ⟺  reality == claim
```

Also note the parenthesisation: `== (y == 1)`, not `== y == 1` — `==` is non-associative
and the latter won't parse.

## Implementation

`lib/ABC147.hs`:

```haskell
import Control.Monad (replicateM)

solveC :: [[(Int, Int)]] -> Int
solveC xs = maximum [length $ filter id c | c <- combinations, consistent c]
  where
    combinations = replicateM (length xs) [True, False]
    consistent c = and [c !! (x - 1) == (y == 1) | (isHonest, sts) <- zip c xs, isHonest, (x, y) <- sts]
```

Reading `consistent` aloud: *for every honest person, for every testimony they made, the
world agrees with the claim.* The three qualifiers map one-to-one onto the comprehension:

| Comprehension fragment | Role |
|---|---|
| `(isHonest, sts) <- zip c xs` | pair each person's label with their testimonies |
| `, isHonest` | the **gate** — bare `Bool` guard drops unkind speakers |
| `, (x, y) <- sts` | flatten to individual testimonies (all of them bind) |
| `c !! (x - 1) == (y == 1)` | reality vs claim |
| `and [...]` | every check must hold |

Two design points:

- **N is derived, not passed.** An earlier signature was
  `solveC :: [[Bool]] -> [[(Int,Int)]] -> Int`, taking the worlds as an argument. That
  makes an invalid state representable (5-person worlds against 2 people's testimonies
  typechecks) and clutters testing. `length xs` is the single source of truth.
- **Two nesting levels, kept separate.** Trying to fuse the world loop and the testimony
  loop into one comprehension (`[zip c xs | c <- combinations]` then drawing from it)
  flattens all 2^N worlds into one check. The world loop belongs *outside*; `consistent`
  takes exactly one world.

### `replicateM`, not `replicate`

```haskell
replicate  3 [True,False] = [[True,False],[True,False],[True,False]]   -- 3 copies
replicateM 3 [True,False] = [[T,T,T],[T,T,F],[T,F,T],...,[F,F,F]]      -- 8 combinations
```

`replicate n x` repeats one value. `replicateM n xs` makes **n independent choices** from
`xs` in all possible ways — in the list monad, choice branches, giving the Cartesian
product `|xs|^n`. It's the runtime-`n` generalisation of a nested comprehension:

```haskell
replicateM 3 [True,False]  ==  [[a,b,c] | a <- [T,F], b <- [T,F], c <- [T,F]]
```

`replicate` couldn't even represent "person 1 honest, person 2 unkind" — all entries would
be identical. Everything used here (`Control.Monad`) is in `base`, no dependency needed.

### Input parsing (`app/Main.hs`)

The format is two-level: per person, a count `A_i` then that many `x y` lines.

```haskell
main :: IO ()
main = do
  n <- getInt
  xs <- replicateM n readTestimonies
  print $ solveC xs

-- Each person's block is a count followed by that many "x y" lines.
readTestimonies :: IO [(Int, Int)]
readTestimonies = do
  a <- getInt
  replicateM a readPair

readPair :: IO (Int, Int)
readPair = do
  ns <- getInts
  case ns of
    [x, y] -> pure (x, y)
    _ -> error "expected two integers"
```

**Nested `replicateM` mirrors the nested input.** The pattern to remember is *read a
count, then read that many things*: because `readTestimonies` is monadic, `a` is bound
before the inner `replicateM` runs. Pure `replicate` cannot express this — the same
distinction as above, now load-bearing for parsing.

`A_i = 0` needs no special case: `replicateM 0 readPair` reads nothing and returns `[]`.

## Verification

| Input | Expected | Got |
|---|---|---|
| sample 1 | 2 | 2 ✓ |
| sample 2 | 0 | 0 ✓ |
| sample 3 | 1 | 1 ✓ |
| N=1, `A_1=0` | 1 | 1 ✓ |
| N=15, all testify "honest" about all others | 15 | 15 ✓ (0.056 s) |

## 7. Lessons to carry forward

- **N ≤ ~20 with a subset/assignment answer ⇒ enumerate all 2^N.** The tiny constraint
  *is* the intended algorithm. Don't invent deduction when brute force is licensed.
- **Propose-and-verify beats propagate-and-deduce for self-referential constraints.** When
  claims are about the unknown itself, there's no valid starting point and no safe
  ordering; checking a complete candidate is local and trivial.
- **`replicateM n xs` for all combinations; `replicate` only copies.** The `M` means
  "independent choices, all ways" in the list monad. Also the idiom for count-prefixed
  input parsing.
- **Comparing two `Bool`s means `==`, not `&&`.** `&&` silently accepts only the
  true-claim direction. Whenever the check is "does reality match the assertion", reach
  for `==`.
- **A sample whose answer is 0 (or otherwise degenerate) is a weak regression test.** The
  `&&` bug passed samples 1 and 2 and failed only sample 3. Run *all* samples before
  believing a fix.
- **Derive parameters inside the function rather than accepting them.** Passing the world
  list in alongside the testimonies made desync representable; `length xs` cannot desync.
- **Complexity rules are contextual.** `!!` is an O(N) trap at N=1e5 (ABC139-C) and a
  non-issue at N=15. Re-derive the budget per problem instead of applying the rule blindly.
</content>
