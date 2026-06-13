# {CONTEST}-{PROBLEM} — How to think about this problem

Problem: {URL}

This document walks through *how to arrive at the solution*, not the code. The goal is
to practice the chain of reasoning so the same moves are available next time.

## 1. Read the constraints first

What are N, M, value ranges, time limit?

What complexity classes do those constraints rule in / out?

- O(N^2) → ?
- O(N log N) → ?
- O(N) → ?

Whatever the algorithm, it must fit the budget. Pin down the target complexity before
designing anything.

## 2. Reframe the problem in your own words

What is the input literally describing? What is the natural-but-naive framing?

Why is that framing hard? (cascading choices, exponential branching, etc.)

Is there a *different axis* to think along — per-item, per-event, per-position — that
decouples the choices? Write the reframed problem in one sentence.

Does the reframed problem match a classical shape you recognise? (scheduling, shortest
path, knapsack, interval cover, two-pointer, monotonic stack, ...)

## 3. Why {DP / greedy / divide-and-conquer / ...}, not the alternatives

What candidate techniques fit the reframed problem?

For each: does the complexity fit? does the structure of the problem support it?

Pick one. State *why* — what property of the problem makes this technique work?

If greedy: state the local rule and sketch the correctness argument (exchange / swap
argument, matroid, etc.).

If DP: state the state, transitions, and why subproblems compose.

## 4. Concrete algorithm

Pseudocode-level steps:

1. ...
2. ...
3. ...

What invariant does each step maintain?

What data structures does it need? (heap, set, segment tree, union-find, ...)

## 5. Check the complexity

Time: ?

Space: ?

Does it fit the constraints from §1?

## 6. Spot-check the answer's range

What's the maximum possible answer? Does it fit in `Int` (64-bit)? Could intermediate
products overflow?

## 7. Lessons to carry forward

- **{Lesson 1}.** Why and when it applies.
- **{Lesson 2}.** ...
- **{Lesson 3}.** ...
