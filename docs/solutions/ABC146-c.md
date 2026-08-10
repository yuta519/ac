# ABC146-C — How to think about this problem

Problem: https://atcoder.jp/contests/abc146/tasks/abc146_c

This walks through *how to arrive at the solution*, not just the code. The interesting
part isn't the arithmetic — it's noticing that the search space collapses from 1e9
candidates to **10 bands**, and that within a band there's nothing left to search at all.

## 1. Read the constraints first

- `1 ≤ A ≤ 1e9`, `1 ≤ B ≤ 1e9`, `1 ≤ X ≤ 1e18`.
- The shop stocks every integer from `1` to `1e9` — nothing larger.
- Time limit 2 s.

Two things fall out of this:

- **1e9 candidates ⇒ you cannot enumerate `N`.** A loop over `1..1e9` is ~1e9 iterations;
  in Haskell that's well past 2 s. So the answer must come from arithmetic, not a scan.
  This is the constraint that matters — pin it down *before* writing the loop.
- **`X ≤ 1e18` is the value-range warning.** The statement itself says input may not fit
  a 32-bit type. On a 64-bit platform Haskell's `Int` holds up to ~9.2e18 so it *would*
  work, but `Integer` costs nothing here and removes the question entirely (see §6).

The `1e9` stock cap is easy to skim past. It's not decoration — sample 2 exists precisely
to punish ignoring it.

## 2. Reframe the problem in your own words

Price of integer `N` is `A × N + B × d(N)`, where `d(N)` is the digit count. With `X` yen,
buy the largest `N` you can afford.

Naive framing: "for each `N` from 1 to 1e9, check if `A×N + B×d(N) ≤ X`, keep the max."
Correct, and far too slow.

Why is it hard? The cost has **two terms that behave differently**. `A × N` grows smoothly
with `N`, but `B × d(N)` is a *step function* — it jumps only when `N` gains a digit, and
is otherwise flat. So cost isn't a clean formula in `N`; it's piecewise.

The reframe — the key move:

> Group the candidates by **digit count**. Since `N ≤ 1e9`, there are only **10 possible
> values of `d(N)`** (1 through 10). Inside one group, `d(N)` is a *constant*, so the
> awkward step term disappears and the cost becomes plainly linear in `N`.

That turns one hard search over 1e9 items into 10 easy subproblems.

## 3. Why arithmetic per band, not binary search or a scan

Candidate techniques:

- **Linear scan over `N`:** O(1e9). Fails §1. Reject.
- **Binary search on `N`:** tempting, and it *does* work — total cost
  `A×N + B×d(N)` is monotonically increasing in `N`, so you can binary search the largest
  affordable `N` in ~30 steps. Perfectly valid, O(log 1e9).
- **Per-digit-count arithmetic:** O(10) — and needs no monotonicity argument, no
  mid-point fencepost care. This is the one below.

The property that makes the arithmetic version work, and the whole point of the reframe:

> **Once `d` is fixed, `B × d` is a constant.** The budget available for the `A × N` part
> is just `X − B×d`, and `A × N` is strictly increasing in `N`. So the best `N` in that
> band is *computed*, not searched: `(X − B×d) div A`, clamped to the band.

There is no search inside a band. That's why this beats binary search on simplicity: the
inner problem isn't "find" but "divide".

## 4. Concrete algorithm

For each digit count `d` from 1 to 10:

```
band is [10^(d-1) .. min(1e9, 10^d - 1)]     -- the d-digit numbers actually in stock
budget = X - B*d                             -- yen left for the A*N part
if budget < 0:  skip this d                  -- can't even pay the digit fee
cand   = budget div A                        -- largest N whose A*N fits
best   = min(bandHigh, cand)                 -- don't exceed the band or the stock cap
if best < bandLow: skip this d               -- no d-digit number is affordable
else: best is this band's candidate
answer = max(0, all candidates)              -- 0 seed = "nothing affordable"
```

Invariants worth naming:

- `budget div A` is the largest `N` with `A×N ≤ budget`, because integer division floors.
- Clamping with `min bandHigh` keeps the candidate inside the band, so the `d` we assumed
  is the digit count it actually *has*. Without the clamp, band `d=1` with `A=2000, B=1,
  X=1e6` would propose `N = 499`, whose real digit count is 3 — so we'd have charged a
  1-digit fee for a 3-digit number and underpriced it.
- The `bandLow` test is what rejects a band honestly: if the affordable value falls below
  the band's floor, no number of that width is buyable.

### Worked example — sample 4: `A=1234 B=56789 X=314159265` (answer `254309`)

```
 d |    X - B*d | (X-B*d)/A |      low |       high |    best | affordable?
 1 |  314102476 |    254540 |        1 |          9 |       9 | YES
 2 |  314045687 |    254494 |       10 |         99 |      99 | YES
 3 |  313988898 |    254448 |      100 |        999 |     999 | YES
 4 |  313932109 |    254402 |     1000 |       9999 |    9999 | YES
 5 |  313875320 |    254356 |    10000 |      99999 |   99999 | YES
 6 |  313818531 |    254309 |   100000 |     999999 |  254309 | YES   <- winner
 7 |  313761742 |    254263 |  1000000 |    9999999 |  254263 | no    <- below low
 8 |  313704953 |    254217 | 10000000 |   99999999 |  254217 | no
 9 |  313648164 |    254171 | 1e8      |  999999999 |  254171 | no
10 |  313591375 |    254125 | 1e9      |       1e9  |  254125 | no

candidates: [9, 99, 999, 9999, 99999, 254309]  →  answer = 254309
```

The non-obvious step is rows **1–5 vs row 6**. In the narrow bands the *band ceiling*
binds (you can afford 254540 but only 9 fits in one digit), while at `d=6` the *budget*
binds (254309 < 999999). From `d=7` on, the budget can't even reach the band's floor —
the digit fee keeps rising while the affordable value keeps falling, so they cross once
and never recover.

Boundary check on the winner:

```
cost 254309 = 1234·254309 + 56789·6 = 314158040 ≤ 314159265  ✓
cost 254310 = 1234·254310 + 56789·6 = 314159274 >  314159265  ✗ (over by 9)
```

Note that every band from 1 to 6 yields a *valid* purchasable number — this is why the
answer is a `maximum` over bands, not "the first/last band that works."

## 5. Check the complexity

Time: **O(10)** — ten bands, constant arithmetic each. (Strictly, `Integer` ops on
~1e18 values, still constant.) Space: O(1).

Comfortably inside 2 s; the samples run in ~0.24 s, essentially all GHC startup.

## 6. Spot-check the answer's range

- Max answer is `1e9` (the stock cap) — trivially fits.
- Intermediates are the risk: `X ≤ 1e18`, and `B × d` with `B ≤ 1e9`, `d ≤ 10` is `≤ 1e10`.
  Both fit a 64-bit `Int` (max ~9.2e18), so `Int` is *safe* here.
- `Integer` was still the choice: arbitrary precision means the overflow question never
  needs answering, and at O(10) operations the cost is irrelevant. When the constraint
  says "may not fit 32 bits", that's a prompt to think about width, not to guess.
- **`div` on a negative numerator rounds toward −∞**, e.g. `(-1) div 1e9 = -1`. Guard
  `X − B×d ≥ 0` *before* dividing. As it happens the `best < bandLow` test would reject
  those cases anyway (verified: 0 differing results across 60 inputs), so the guard is
  belt-and-braces rather than load-bearing — but relying on a negative intermediate to be
  caught downstream is a bad habit.

## 7. Lessons to carry forward

- **A step-function term ⇒ group by its value.** When cost mixes a smooth term with one
  that only jumps at boundaries (`d(N)`, `floor(log)`, bucket index), partition the domain
  so the jumpy term is *constant* inside each part. The remaining subproblem is usually
  trivial. This is the whole solution here.
- **Bound the number of groups from the constraints.** `N ≤ 1e9` ⇒ at most 10 digit
  counts. Recognising that the group count is tiny is what makes "iterate over groups"
  obviously affordable.
- **Inside a monotone band, don't search — divide.** If `cost = A×N + const` and you have
  budget `R`, the answer is `R div A`. Reaching for binary search (or worse, a scan) when
  floor division answers directly is over-engineering. Ask "is this linear in `N`?" first.
- **Clamp candidates back into the band you assumed.** The band assumption (`d` digits)
  must hold for the value you return, or you priced it wrong. `min bandHigh` enforces the
  assumption; `< bandLow` detects when the band is empty of affordable numbers.
- **Read the stock/domain cap, not just the value constraints.** "Integers from 1 to 1e9"
  is a hard ceiling on the answer, separate from `A`/`B`/`X` ranges. Sample 2
  (`2 1 100000000000` → `1000000000`) is exactly the test for it.
- **Seed the max with the failure value.** `maximum (0 : candidates)` handles "nothing is
  affordable" (sample 3) without a special case — and avoids `maximum []` crashing on the
  empty list.
- **`=` is not a binding form inside a list comprehension.** Use a `let` in the
  comprehension, or hoist to `where`. (`[y | ..., y = expr]` is a parse error; the
  qualifier forms are generators, guards, and `let`.)
- **`f x + 1` parses as `(f x) + 1`.** Application binds tighter than any operator, so
  recursing with `go n + 1` re-enters on the same `n` — an infinite loop, not an
  increment. Write `go (n + 1)`. Same rule bites when passing converted arguments:
  `f fromIntegral a` is `f` applied to *two* things, not one; write `f (fromIntegral a)`.
- **`10 ^ (d-1)` vs `(d-1) ^ 10` — check which is the base.** Swapping them agrees at
  `d=1` and diverges immediately after, so a single spot-check at the first value proves
  nothing. Print a small table when a formula is supposed to generate `1, 10, 100, …`.
</content>
