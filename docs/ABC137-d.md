# ABC137-D — How to think about this problem

Problem: https://atcoder.jp/contests/abc137/tasks/abc137_d

This document walks through *how to arrive at the solution*, not the code. The goal is to
practice the chain of reasoning so the same moves are available next time.

## 1. Read the constraints first

N, M ≤ 10^5. That single line rules out a lot:

- O(N · M) ≈ 10^10 is too slow → no naive 2D DP over (job, day).
- O(N^2) ≈ 10^10 is too slow → no all-pairs comparison.
- O(N log N) ≈ ~2·10^6 fits comfortably → aim for this.

Whatever the algorithm, it must touch each job a small number of times with at most a
log factor. That points away from DP and toward sorting + a clever sweep.

## 2. Reframe the problem in your own words

The input is "job i pays B_i in A_i days." Your first instinct is to think about days:
"what should I do on day 1, day 2, ...?" That framing is hard — the choice on day 1
constrains everything downstream.

Flip the framing from *day-centric* to *job-centric*:

> If I want to take job i, how many days am I allowed to start it on?
> Days I can work are 0, 1, …, M − 1 ("today" counts — you can begin immediately).
> If I start on day d, reward arrives on day d + A_i, which must be ≤ M.
> So d ranges over {0, 1, …, M − A_i}, giving **D_i = M − A_i + 1** valid start days.

Now every job has an independent capacity. The problem becomes:

> Each job takes 1 day. Job i can be scheduled on any of D_i distinct days. At most
> one job per day. Maximize total reward.

This is a known classical problem ("scheduling unit jobs with deadlines and profits").
Recognising it is the main insight; the rest is mechanical.

> ⚠️ **Off-by-one trap.** It is tempting to write D_i = M − A_i ("latest start day").
> That formula is wrong here. Concrete check, using sample 1: M = 4, one of the jobs
> has A = 4, B = 3.
>
> - With D = M − A: D = 0. You'd filter this job out as "infeasible". Wrong — you
>   can start it on day 0 and the reward arrives on day 4 ≤ M. It's selectable.
> - With D = M − A + 1: D = 1. You have exactly one valid start day (day 0). Correct.
>
> Always frame D as **"number of valid slots"**, not "latest day index". The +1
> disappears and the sweep invariant becomes self-consistent.

## 3. Why greedy, not DP

Once the problem is in scheduling form, ask: does a *local* rule produce the global
optimum? The candidate rule:

> Process jobs in order of deadline. Keep the most valuable jobs that still fit.

Why this is plausible: jobs with earlier deadlines are more constrained, so commit to
them first; jobs with later deadlines have flexibility to "fall back" into earlier slots.

Why it's correct (exchange argument sketch): suppose some optimal solution disagrees
with the greedy choice — it kept a less-valuable job j₁ over a more-valuable job j₂.
Both have deadlines that allow either to fit somewhere in the schedule, so we can swap
j₁ out for j₂ without violating any deadline, and the total reward doesn't go down.
Repeating the swap turns the optimal solution into the greedy one without losing value.
Hence greedy ≥ optimal, so greedy = optimal.

This kind of "swap argument" is the standard correctness proof for scheduling greedies
and is worth memorising — it shows up in many problems.

## 4. Concrete greedy: sort + min-heap

The greedy needs to answer one question at each step: "I just considered job i; is my
current selected set still feasible, and if not, which job should I drop?"

- "Drop the worst" → drop the job with the *smallest reward*. (Why min, not max?
  Because losing a small reward hurts the total least. We want to keep the big
  ones.)
- Need fast access to the minimum → priority queue (min-heap).

Two orderings are at play; keep them separate in your head:

| ordering    | what it does       | when it's set up                            |
| ----------- | ------------------ | ------------------------------------------- |
| sort by D   | order we *visit*   | once, up front, before the sweep            |
| heap on B   | the *selected set* | grows/shrinks during the sweep, never sorted explicitly |

Algorithm:

1. Compute D_i = M − A_i for each job. Discard jobs with D_i ≤ 0 (infeasible).
2. Sort jobs by D_i ascending.
3. Sweep through jobs in that order, maintaining a min-heap of the rewards of the
   currently selected jobs.
4. For each job: push its reward; if the heap now has more entries than the current
   deadline allows, pop the smallest.
5. Answer = sum of what's left in the heap.

Step 4's invariant: after processing every job with deadline ≤ d, the heap holds at
most d jobs — and exactly the d most valuable feasible ones.

### Worked example

Setup: M = 4 (you have 4 days available — day 1, day 2, day 3, day 4). Four jobs:

| job | A | B  | meaning                                |
| --- | - | -- | -------------------------------------- |
|  1  | 3 | 50 | takes 1 day, paid 3 days later         |
|  2  | 2 | 40 | takes 1 day, paid 2 days later         |
|  3  | 2 | 30 | takes 1 day, paid 2 days later         |
|  4  | 1 | 70 | takes 1 day, paid 1 day later          |

For each job, the **number of valid start days** is D = M − A + 1 (since you may start
on day 0 through day M − A, all yielding a reward day ≤ M):

| job | A | B  | D |
| --- | - | -- | - |
|  1  | 3 | 50 | 2 |
|  2  | 2 | 40 | 3 |
|  3  | 2 | 30 | 3 |
|  4  | 1 | 70 | 4 |

(In this example no job has A = M, so the answer also happens to come out right with
the off-by-one formula D = M − A. That's the trap: the worked example doesn't expose
it. See sample 1 of the actual problem — `M=4`, job `(A=4, B=3)` — which *requires*
the +1 to be selectable.)

Sort by D ascending (so we handle the most urgent jobs first). The order above is
already sorted.

Now sweep through the jobs, maintaining a "selected set" of jobs we plan to take. The
selected set is stored as a min-heap so we can quickly find and drop its weakest
member.

The key check at each step: *after processing every job with capacity ≤ d, the
selected set must contain at most d jobs* — because that's the most jobs that can fit
into d slots.

```
Step | Consider | Add to selection | Selection state  | Capacity (= D) | Action
-----|----------|------------------|------------------|----------------|------------------
  1  | (D=2,50) | push 50          | {50}             |       2        | size 1 ≤ 2, keep
  2  | (D=3,40) | push 40          | {40, 50}         |       3        | size 2 ≤ 3, keep
  3  | (D=3,30) | push 30          | {30, 40, 50}     |       3        | size 3 ≤ 3, keep
  4  | (D=4,70) | push 70          | {30, 40, 50, 70} |       4        | size 4 ≤ 4, keep
```

Final selection: {30, 40, 50, 70}. Answer = 30 + 40 + 50 + 70 = **190**.

Note this differs from the old (buggy) trace: with the corrected capacity, job 3
(B=30) survives because there *is* room for it. Good — that matches the intuition
that having more days available shouldn't make you accept fewer jobs.

No drops happened in this trace. To see why the push-then-maybe-pop pattern matters,
imagine M = 2 (so D values become 0, 1, 1, 2 — and the first job is filtered out as
infeasible). The remaining sweep would be:

```
Step | Consider | Selection state    | Capacity | Action
-----|----------|--------------------|----------|------------------
  1  | (D=1,40) | {40}               |    1     | size 1 ≤ 1, keep
  2  | (D=1,30) | push → {30,40}     |    1     | size 2 > 1, drop min (30)
  3  | (D=2,70) | push → {40, 70}    |    2     | size 2 ≤ 2, keep
```

Step 2 is the interesting one: we *tentatively admit* job 3 even though the selection
is already full, then immediately drop the smallest. Here the smallest happens to be
the job we just inserted — it's the right move (job 2 is more valuable). But if job
3's reward had been 60 instead of 30, we'd push 60, get {40, 60}, and drop 40 —
*replacing* a previously-selected job with a better one. Letting the heap decide
which to drop is what makes the algorithm work uniformly.

## 5. Check the complexity

- Sort: O(N log N).
- Each job: one heap push + at most one heap pop, each O(log N).
- Total: O(N log N). Well within budget.

## 6. Spot-check the answer's range

B_i ≤ 10^4, N ≤ 10^5, so the maximum total reward is 10^9. That fits in a 64-bit
integer but overflows 32-bit. Worth noting before picking a type.

## 7. Haskell implementation: things that actually bit me

Five concrete bugs hit me on the way from "I understand the algorithm" to "the
samples pass". Each one is worth telling as a story so future-me recognises the
shape, not just the rule.

### Story 1 — "What do I even use as a min-heap?"

Haskell's `containers` package has no `Data.Heap`. The trick: **use `Data.Set`**.
A `Set` is a balanced BST, but the API gives you all the heap operations you need
at the same O(log n) cost:

| min-heap op | `Data.Set` |
| ----------- | ---------- |
| empty       | `Set.empty` |
| push x      | `Set.insert x s` |
| peek min    | `Set.findMin s` |
| pop min     | `Set.deleteMin s` |
| size        | `Set.size s` |

That's it. No need for an external library, and `containers` is already in your
build deps.

### Story 2 — "The set has fewer entries than I inserted"

I expected `Set Int` keyed on rewards to behave like a multiset of rewards. It
doesn't — sets deduplicate. Concrete failure case: M = 3, jobs `[(A=1,B=50),
(A=1,B=50), (A=1,B=50)]`. All three have D = 3, so all three should fit and the
answer should be 150.

```
push 50 → {50}      -- ok
push 50 → {50}      -- silent no-op! the second job is gone
push 50 → {50}      -- silent no-op!
sum {50} = 50       -- wrong, expected 150
```

The fix: store `(B, idx)` tuples where `idx` is a unique tag (the loop index).
Now `(50, 0)`, `(50, 1)`, `(50, 2)` are three distinct elements:

```
push (50, 0) → {(50,0)}
push (50, 1) → {(50,0), (50,1)}
push (50, 2) → {(50,0), (50,1), (50,2)}
sum [b | (b,_) <- toList] = 150  ✓
```

### Story 3 — "Will min-heap-on-B still work after I add the tag?"

Yes — because tuples compare **lexicographically** in Haskell. The first element
decides; the second only breaks ties.

```
(40, 7) < (50, 0)   because 40 < 50, second element doesn't matter
(40, 7) < (40, 9)   first elements tie, fall back to 7 < 9
```

So `findMin` / `deleteMin` on `Set (Int, Int)` still pick the smallest B. The tag
only matters when two jobs share the same B, and in that case either is equally
fine to evict — picking by smallest `idx` is harmless.

### Story 4 — "My answer is consistently 1 too big"

I wrote this:

```haskell
go (deleteMin heap') rest idx + 1
```

intending to recurse with index `idx + 1`. Haskell parsed it as:

```haskell
(go (deleteMin heap') rest idx) + 1
```

— call `go` with the *un-incremented* `idx`, then add 1 to whatever it returned.
Two bugs at once: the recursion uses a stale index (so all tuples get tag 0 and
Story 2 strikes again), and the final answer is off by the recursion depth.

The fix is one pair of parentheses:

```haskell
go (deleteMin heap') rest (idx + 1)
```

Function application binds tighter than `+` in Haskell. Always parenthesise
arithmetic in argument position.

### Story 5 — "Sample 1 says the answer is 5, mine says 2"

This is Story 1 from section 2 of this doc, rediscovered the hard way: the formula
D = M − A drops a job that should be kept. Sample 1 has a job with A = M = 4, and
under the wrong formula it gets filtered as "infeasible" with D = 0. Test failure
was the only way to find this — the worked example here doesn't have any job with
A = M, so it passes both formulas and hides the bug. Lesson: a worked example you
can hand-trace is not a regression test. Run the actual sample inputs.

## 8. Lessons to carry forward

- **Constraints first.** They tell you which complexity class is allowed before you
  even read the problem statement carefully.
- **Reframe day-centric → job-centric.** When choices on a timeline cascade, look for
  a per-item attribute (here: capacity) that decouples them.
- **Frame as "count of slots", not "latest index".** When mapping a deadline to a
  capacity, off-by-ones love to live in the gap between "the latest day d such that
  …" and "the number of valid days d such that …". Pick whichever framing is
  *self-consistent with your sweep invariant* and stick with it.
- **Two orderings, two roles.** The outer sort and the inner heap solve different
  problems. Don't conflate them — name them differently when you write the code.
- **Recognise the classical shape.** "Unit jobs with deadlines and profits" is a
  named problem. The more named problems you recognise, the faster step 3 becomes.
- **Swap argument.** When you suspect a greedy is correct, try: "if some optimal
  disagrees with my rule, can I swap toward my rule without losing value?" If yes,
  greedy is optimal.
- **A "passing" worked example doesn't validate the formula.** Validation needs an
  example that *exercises the boundary* (here: a job with A = M), not just a
  representative one. Always run the real sample inputs.
