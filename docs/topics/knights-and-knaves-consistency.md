# Knights and knaves: hypothesize-a-world, then verify

This note is about the **logic** genre behind ABC147-C — truth-teller / liar puzzles
(Smullyan's "knights and knaves"). No solution here; the goal is to make the reasoning
shape automatic so the problem becomes a straightforward application of it.

The domain is **propositional logic**, not number theory or geometry. You decide whether
a set of statements about *each other's* honesty is internally consistent.

Write this one into muscle memory: the same "hypothesize a full assignment, then locally
verify it" shape shows up in SAT-flavoured problems, constraint puzzles, and any
"self-referential claims" setup.

---

## 1. The cast: two kinds of people

```
┌───────────────────────────────┐   ┌───────────────────────────────┐
│  HONEST                       │   │  UNKIND                       │
│                               │   │                               │
│  Every statement they make    │   │  Statements may be true OR    │
│  is TRUE.                     │   │  false, freely.               │
│                               │   │                               │
│  ⟹ each one is a BINDING      │   │  ⟹ carries ZERO information   │
│     constraint you must obey  │   │     — can never contradict    │
└───────────────────────────────┘   └───────────────────────────────┘
```

> ⚠️ **The trap.** This is *not* "honest tells the truth, liar always lies." An unkind
> person is **unconstrained**, not inverted. If liars always lied, their statements would
> also be binding (as negations) and this would be a different, symmetric puzzle. Here,
> half the constraints simply evaporate.

## 2. Notation

A statement is "person X asserts person Y's status":

```
        "Y is honest"
   (X) ───────────────▶ (Y)
```

## 3. The key picture: statements pass through a GATE

Whether a statement constrains anything depends on the **speaker's** status:

```
   speaker HONEST                      speaker UNKIND
   ─────────────────                   ─────────────────

    statement                          statement
        │                                  │
        ▼                                  ▼
   ╔═════════╗                        ╔═════════╗
   ║  OPEN   ║  gate                  ║ CLOSED  ║  gate
   ╚═════════╝                        ╚═════════╝
        │                                  ╳
        ▼                              (discarded)
   MUST be true                       no constraint at all
   ✓ check it                         ✓ nothing to check
```

**Constraints flow only from honest speakers.** This asymmetry is why the puzzle isn't a
system of equations — which "equations" exist depends on the answer you're testing.

## 4. Worked toy example (N = 2)

```
              "B is honest"
        (A) ───────────────▶ (B)

        (A) ◀─────────────── (B)
              "A is unkind"
```

All four possible worlds (`H` = honest, `U` = unkind):

**World 1: A=H, B=H**

```
 A is H → gate OPEN → "B is honest" must hold → B is H  ✓
 B is H → gate OPEN → "A is unkind" must hold → A is H  ✗ CONTRADICTION

      (A:H) ──✓──▶ (B:H)
      (A:H) ◀──✗── (B:H)       ✗ INCONSISTENT
```

**World 2: A=H, B=U**

```
 A is H → gate OPEN   → "B is honest" must hold → B is U  ✗ CONTRADICTION
 B is U → gate CLOSED → ignore

      (A:H) ──✗──▶ (B:U)       ✗ INCONSISTENT
```

**World 3: A=U, B=H**

```
 A is U → gate CLOSED → ignore, no constraint
 B is H → gate OPEN   → "A is unkind" must hold → A is U  ✓

      (A:U) ──╳──▶ (B:H)       (statement discarded)
      (A:U) ◀──✓── (B:H)       ✓ CONSISTENT — 1 honest
```

**World 4: A=U, B=U**

```
 A is U → gate CLOSED → ignore
 B is U → gate CLOSED → ignore

      (A:U) ──╳──▶ (B:U)
      (A:U) ◀──╳── (B:U)       ✓ CONSISTENT — 0 honest
```

### Summary

| World | A | B | A's claim | B's claim | Verdict | # honest |
|---|---|---|---|---|---|---|
| 1 | H | H | checked ✓ | checked ✗ | ✗ inconsistent | — |
| 2 | H | U | checked ✗ | ignored | ✗ inconsistent | — |
| 3 | **U** | **H** | ignored | checked ✓ | **✓ consistent** | **1** |
| 4 | U | U | ignored | ignored | ✓ consistent | 0 |

Best consistent world → **1 honest person**.

Two structural facts this reveals:

- **All-unkind is always consistent** — every gate is closed, so there is nothing to
  check. A consistent world therefore always exists; the answer is never "impossible."
- **Honesty is expensive.** Labelling someone honest *opens gates*, creating more ways to
  fail. More honest people ⇒ strictly more constraints to satisfy.

## 5. Why it is self-referential

The property being asserted is the same property you're solving for:

```
        ┌──────────────────────────────────┐
        │                                  │
        ▼                                  │
   assume who is honest ──▶ that opens ────┘
                            certain gates ──▶ whose statements
                                              are about ... who is honest
```

You can't resolve people one at a time down a chain: whether person 3's words matter
depends on person 3's status, which person 1's words may constrain, which depends on
person 1's status, and so on.

> **Consistency is a property of a whole configuration, not of an individual.**

That is the core conceptual point, and the reason the natural approach is to *propose a
complete assignment* and then check it, rather than to deduce statuses incrementally.

## 6. The definition of consistent, precisely

```
A configuration (an H/U label for every person) is CONSISTENT
  ⟺  for every person labelled H,
        every statement they made agrees with the configuration's labels.

Statements by U-labelled people are never checked.
```

No other rule. Note the check is pure **local verification**: given a full labelling, you
read off labels and compare. Nothing is deduced, nothing is searched — which makes the
verification step cheap and hard to get wrong.

## 7. The two layers

The problem shape is a consistency check wrapped in an optimisation:

```
   ┌──────────────────────────────────────────────┐
   │  MAXIMISE  (combinatorial optimisation)      │
   │    over all candidate configurations ...     │
   │                                              │
   │    ┌────────────────────────────────────┐    │
   │    │  CONSISTENT?  (propositional logic)│    │
   │    │    open honest gates, verify       │    │
   │    └────────────────────────────────────┘    │
   │                                              │
   │  ... keep the one with the most honest       │
   └──────────────────────────────────────────────┘
```

Inner layer: §6's local check. Outer layer: pick the best consistent world.

## 8. The mental model to carry

> **Hypothesize a world → open the honest people's gates → verify their claims against
> that same world.**

## Lessons to carry forward

- **"Liars are unconstrained" ≠ "liars always lie."** Read which variant the statement
  specifies; it changes whether their testimony generates constraints at all.
- **Asymmetric constraints:** when only one class of actor produces obligations, the
  constraint set depends on the hypothesis — so you verify assignments rather than solve
  equations.
- **Self-reference blocks incremental deduction.** When claims are about the unknown
  itself, consistency belongs to whole configurations; propose-then-verify is the natural
  move.
- **A trivially consistent baseline often exists** (here: all unkind). Finding it early
  tells you the answer's floor and that no "impossible" case needs handling.
- **Adding "constrained" actors monotonically tightens the system** — useful intuition
  for why the optimum is not simply "everyone honest."
- **Before designing anything, read the constraint on N.** As always, its size decides
  which class of approach is admissible — and for this genre it is often far smaller than
  in the array problems, which is itself a hint.

---

Related: [[haskell-algorithm-ramp]] for the general practice loop (state → type → simple
structures → notes).
