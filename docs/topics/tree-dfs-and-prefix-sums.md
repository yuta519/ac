# Roadmap: building up to ABC138-D

ABC138-D combines three independent skills. Trying to learn all three at once is hard.
This doc breaks the problem into pillars, lists prerequisite problems for each pillar
in order of difficulty, and gives a 2-week plan to put it all together.

## The three pillars

```
                    ABC138-D (capstone)
                          ▲
        ┌─────────────────┼─────────────────┐
        │                 │                 │
   Tree input +      Prefix sums /     Reframe ops:
   adjacency +        Imos method      "what touches
   DFS basics       (差分配列)            this node?"
```

The first two pillars are **techniques** — you can drill them in isolation. The third
is a **thinking habit** that comes from reading editorials and noticing the same flip
pattern recur.

> ⚠️ The links and difficulties below are written from memory. Some problem IDs (esp.
> ATC001 task slugs) and difficulty ratings may be off. Use your `ojf` picker
> (`ojf 400 800`) or open each link to verify before committing time.

---

## Pillar 1 — Trees, adjacency, DFS

The skill to build: **read N−1 edges, build an adjacency list, DFS from a root,
recurse to children while avoiding the parent.**

| # | problem | difficulty | link | what it teaches |
| - | ------- | ---------- | ---- | --------------- |
| 1 | ATC001-A: 深さ優先探索 | ~300 | [link](https://atcoder.jp/contests/atc001/tasks/dfs_a) | DFS on a grid. Gets the recursion shape into muscle memory before adding tree input parsing. |
| 2 | ABC126-D: Even Relation | ~700 | [link](https://atcoder.jp/contests/abc126/tasks/abc126_d) | Tree DFS + accumulating distance parity down the tree. *Structurally very close to ABC138-D* but with a simpler payload. |
| 3 | ABC133-E: Virus Tree 2 | ~1100 | [link](https://atcoder.jp/contests/abc133/tasks/abc133_e) | Tree DFS where the accumulated value is a count being multiplied. Practice carrying state through recursion. |

**Goal after this pillar:** you can read N−1 undirected edges, build an `adj` array,
and write a `dfs node parent acc` recursion that does *something* with `acc` at every
node.

---

## Pillar 2 — Prefix sums / Imos method (差分配列)

The skill to build: **instead of applying each "add x to range [l, r]" eagerly,
record `+x` at l and `-x` at r+1, then take a prefix sum once at the end.** ABC138-D
is the tree analogue of this trick.

| # | problem | difficulty | link | what it teaches |
| - | ------- | ---------- | ---- | --------------- |
| 1 | ABC037-C: 総和 | ~200 | [link](https://atcoder.jp/contests/abc037/tasks/abc037_c) | Plain 1D prefix sums. The "compute once, query many" pattern. |
| 2 | ABC014-C: AtColor | ~600 | [link](https://atcoder.jp/contests/abc014/tasks/abc014_c) | The canonical 1D Imos problem — "add x to range [l, r]" repeated many times. **This is the one to fully internalise.** |
| 3 | ABC035-C: オセロ | ~600 | [link](https://atcoder.jp/contests/abc035/tasks/abc035_c) | Imos with toggle (XOR) instead of sum. Same idea, different combiner — proves the pattern generalises. |

**Goal after this pillar:** when you see "many range updates, then read each value,"
your hand reaches for `diff[l] += x; diff[r+1] -= x` automatically, and you take the
prefix sum at the end without thinking.

After this pillar, ABC138-D should feel like: "Oh, this is Imos but the 'range' is
a subtree and the 'sweep' is a DFS."

---

## Pillar 3 — Reframing perspective

Not a problem set — a habit. Read editorials for problems where the naive *"for each
op, do work"* is too slow. Notice the flip:

> The editorial reframes "what does op j touch?" into "what ops touch element i?"

After 5–10 editorials with this shape, you'll start spotting the flip *before* you
read them.

Editorials worth reading (after solving or attempting the problem):

| problem | difficulty | link | flip to notice |
| ------- | ---------- | ---- | -------------- |
| ABC014-C: AtColor | ~600 | [link](https://atcoder.jp/contests/abc014/tasks/abc014_c) | "for each op, paint range" → "for each cell, sum ops covering it" |
| ABC179-D: Leaping Tak | ~1300 | [link](https://atcoder.jp/contests/abc179/tasks/abc179_d) | Different problem, same mindset: aggregate transitions instead of iterating per-op |

---

## 2-week plan

| day | task |
| --- | --- |
| 1   | ABC037-C — get the prefix-sum primitive working |
| 2   | ABC014-C — solve it. Then read the editorial. Then re-solve from scratch a day later. |
| 3   | ATC001-A — DFS muscle memory |
| 4   | ABC126-D — first real tree DFS with accumulation. Closest in spirit to ABC138-D. |
| 5   | Re-read your `docs/ABC137-d.md`. Both 137-D and 138-D share "aggregate first, sweep once." |
| 6   | ABC035-C — Imos with a non-sum combiner |
| 7   | Buffer / catch-up day. Or read an editorial for a problem you already solved. |
| 8   | ABC133-E — DFS carrying state, slightly harder |
| 9   | Re-read `docs/ABC138-d.md`. Trace sample 1 by hand without looking. |
| 10  | **Re-attempt ABC138-D from scratch.** It should feel mechanical now, not novel. |
| 11–14 | Stretch problems — ABC202-E "Count Descendants", ABC163-D, or whatever the next one in your queue is. |

---

## Calibration tips

- **If a "prerequisite" problem feels hard:** that's the right level. Don't skip it
  to get to ABC138-D faster — the whole point is that the skills compound.
- **If a "prerequisite" problem feels trivial:** still write it up, even briefly. The
  goal is to make the technique automatic, not to demonstrate you can do it once.
- **If you get stuck for >30 minutes on any single problem:** read the editorial.
  Solving is not the same as learning. Reading editorials early is fine; what matters
  is that you can re-solve the problem from scratch a day later without referring
  to it.

## Lessons to carry forward

- **Decompose unfamiliar problems by skill, not by topic.** ABC138-D isn't really a
  "tree problem" — it's a *prefix-sum problem on a tree*. Naming the underlying
  techniques makes the prerequisite problems obvious.
- **Practice each technique on the simplest possible problem first.** Imos on a 1D
  array is much easier to debug than Imos on a tree. Build the abstraction in
  isolation, then compose.
- **Editorials are not cheating.** They are *the* learning material. The skill being
  trained is recognising patterns next time, not deriving them on the spot.
