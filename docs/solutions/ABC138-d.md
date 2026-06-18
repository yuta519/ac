# ABC138-D — How to think about this problem

Problem: https://atcoder.jp/contests/abc138/tasks/abc138_d

This document walks through *how to arrive at the solution*, not the code. The goal is
to practice the chain of reasoning so the same moves are available next time.

## 0. Problem categories

This is the intersection of several patterns. Recognising any one of them gets you
started; recognising all three is the full picture.

- **Tree** — N−1 edges connecting N nodes, rooted at node 1.
- **Subtree update, point query** — each operation modifies a whole subtree; the
  output asks the value at every individual node.
- **Lazy aggregation + DFS propagation** — instead of applying each update eagerly
  (slow), record updates at their target node, then do *one* DFS that sweeps the
  accumulated values downward. This is the tree analogue of the **prefix-sum / Imos
  method** (差分配列) on arrays.

If you've seen Imos / difference arrays before: this problem is the tree version of
the same trick. If you haven't: you're learning a very general pattern that shows up
in many tree problems.

## 1. Read the constraints first

N, Q ≤ 2·10^5.

- O(N · Q) ≈ 4·10^10 — way too slow. Rules out naive "apply each op by walking the
  subtree."
- O((N + Q) log N) ≈ 7·10^6 — fits.
- O(N + Q) — also fits and is the cleanest target.

Whatever the algorithm, each op gets touched O(1) or O(log N) times. That points
*away* from "do something for each (op, node) pair" and *toward* "aggregate first,
sweep once."

## 2. Reframe the problem in your own words

Literal reading: "Q times, add x to every node in the subtree rooted at p. Print the
final value at every node."

Naive framing: for each operation, walk the subtree of p and add x to every node
visited. This is the obvious approach — and it's the trap. Subtree sizes can be N,
so worst case is O(N·Q).

Reframe by flipping perspective. Instead of "what does this op touch?", ask **"what
ops touch this node?"**:

> The final value at node v is the sum of x over all operations (p, x) where p is an
> ancestor of v (or p = v itself).

This phrasing is gold because:

- Every op contributes to exactly one chain: from its target node down to all
  descendants.
- "Chain from root downward, accumulating" is something a single DFS can do.
- We can record each op in O(1) at its target, then let one DFS distribute the sums.

Recognise the shape: this is **path-sum-from-root** on a tree. Same idea as prefix
sums on an array, just walking parent→child instead of left→right.

## 3. Why DFS accumulation, not eager updates

Two candidate techniques after the reframe:

| approach | complexity | reasoning |
| --- | --- | --- |
| For each op, walk the subtree and add x to each node | O(N · Q) worst case | naive, too slow |
| For each op, record `counter[p] += x`. Then one DFS accumulates parent → child | O(N + Q) | just right |

The second works because of a beautiful invariant: when we DFS from the root and
arrive at node v from parent u carrying accumulated sum `acc`, the answer for v is
exactly `acc + counter[v]`. Every op `(p, x)` where p is an ancestor of v (or p = v)
contributes — because either we already added x to `acc` when we passed through p, or
we add it now at v itself.

This is the same insight as prefix sums: don't pay the cost of each individual
update; let the structure do the summation in one sweep.

## 4. Concrete algorithm

1. Read N−1 **undirected** edges. Build an adjacency list (each edge added in both
   directions).
2. Read Q operations `(p, x)`. Build an array `counter[1..N]` where
   `counter[p] += x`. (Multiple ops at the same node just sum.)
3. DFS from node 1, carrying an accumulated value `acc` down the tree. Track the
   parent so we don't revisit it.
   - On entering node v from parent u with accumulator `acc`:
     - `answer[v] = acc + counter[v]`
     - For each neighbor w ≠ u, recurse with `acc' = answer[v]`.
4. Print `answer[1..N]` separated by spaces.

### Why edges are undirected on input

The input format gives N−1 lines of `a b`, meaning "there is an edge between a and
b." It does **not** mean "a is the parent of b." The rooting at node 1 is something
*you* impose during the DFS — at each step, the parent is whoever you came from.

This is standard for AtCoder tree problems. Always build an undirected adjacency list
first; root by DFS.

### Worked example

Sample 1: N = 4, Q = 3.

```
Edges: (1, 2), (2, 3), (2, 4)
Ops:   (2, 10), (1, 100), (3, 1)
```

The tree, rooted at 1:

```
        (1)
         |
        (2)
        / \
      (3) (4)
```

#### Step 1: build adjacency list (undirected)

```
adj[1] = [2]
adj[2] = [1, 3, 4]
adj[3] = [2]
adj[4] = [2]
```

#### Step 2: aggregate operations into `counter`

```
op (2, 10):   counter[2] += 10   → counter = [_, 0,  10, 0, 0]
op (1, 100):  counter[1] += 100  → counter = [_, 100, 10, 0, 0]
op (3, 1):    counter[3] += 1    → counter = [_, 100, 10, 1, 0]
                                              ^index 0 unused
```

Critical point: we **do not** propagate yet. Each op touches exactly one cell.

#### Step 3: DFS from node 1, carrying `acc`

Visualise `acc` as a bag of money you carry as you walk down. At each node, you
collect that node's `counter` into the bag, write down what's in the bag (that's
the answer), then visit children with the same bag.

```
DFS step                    acc (incoming)  counter[v]  answer[v] = acc + counter[v]
---------------------------+---------------+-----------+----------------
visit 1 (parent = none)         0              100         100
  visit 2 (parent = 1)          100             10         110
    visit 3 (parent = 2)        110              1         111
    visit 4 (parent = 2)        110              0         110
```

Same trace as a tree diagram, with `(answer)` at each node:

```
          (100)              ← node 1: acc=0,   counter=100, answer=100
            |
          (110)              ← node 2: acc=100, counter=10,  answer=110
          /   \
       (111) (110)           ← node 3: acc=110, counter=1,   answer=111
                             ← node 4: acc=110, counter=0,   answer=110
```

Final answer: `100 110 111 110`. Matches the expected output. ✓

#### Why this is correct

Look at node 3. Its answer is 111 = 100 + 10 + 1.

- 100 came from op `(1, 100)` — node 1 is an ancestor of 3.
- 10 came from op `(2, 10)` — node 2 is an ancestor of 3.
- 1 came from op `(3, 1)` — 3 is itself.

The DFS picked up exactly those three contributions, in order, as it walked down the
path 1 → 2 → 3. That is the path-sum invariant in action.

## 5. Check the complexity

- Build adjacency list: O(N).
- Aggregate ops: O(Q).
- DFS: visits each node once, examines each edge twice (once per endpoint) → O(N).
- Total: **O(N + Q)**. Comfortably fits.

## 6. Spot-check the answer's range

Each x ≤ 10^4, Q ≤ 2·10^5, so a node's answer can reach 10^4 · 2·10^5 = 2·10^9.
That overflows 32-bit signed but fits in 64-bit. In Haskell, plain `Int` is 64-bit on
modern platforms — fine. In C++, use `long long`.

## 7. Haskell implementation notes

### Choosing data structures

| need | option |
| --- | --- |
| adjacency list | `Data.Array Int [Int]` built with `accumArray (flip (:)) [] (1, n)` |
| `counter` array | `Data.Array Int Int` or `IOArray` if you want mutability |
| `answer` output | accumulate during DFS into a list, or write to an `IOArray` |

`accumArray` is the right tool for "build an array from many (index, value) pairs" —
it's O(N + edges) and gives you O(1) lookup. The combining function `(flip (:))` just
prepends each new neighbor to the list at that index.

### Why pure recursion suffices (no `IOArray` needed)

The DFS only reads `counter` and `adj` — it doesn't mutate them. The result can be
built as a list of `(node, answer)` pairs, then sorted by node and printed. So a
plain recursive function `dfs :: Int -> Int -> Int -> [(Int, Int)]` (`node`, `parent`,
`acc`) returning `(node, answer):children` works fine.

If you find list concat slow, switch to `Data.IntMap` or use `IOArray` for output.
But for N = 2·10^5, the pure version should pass.

### Trap: stack overflow on linear tree

If the tree is a path (1 → 2 → 3 → … → N), pure recursion in Haskell can blow the
stack at N = 2·10^5. Two fixes:

1. Increase stack size at the GHC level: `+RTS -K1G -RTS`.
2. Manage the DFS stack manually (use an explicit `[Int]` as a worklist).

Option 1 is simpler and AtCoder allows runtime flags via build options. Worth knowing
this trap exists before you debug a mysterious WA/RE.

### Output formatting

Sample output is N values separated by newlines (re-check the problem). `mapM_ print
answers` is fine. If it's space-separated, use `putStrLn $ unwords (map show answers)`.

## 8. Lessons to carry forward

- **Trees on input are undirected.** Build an undirected adjacency list; rooting is
  something *you* do via DFS from node 1 (or whichever root the problem specifies).
- **Subtree update, point query → DFS accumulation.** When ops affect entire
  subtrees and queries are per-node, don't propagate eagerly. Record at the target,
  sweep once with DFS. This is the tree version of prefix sums (Imos / 差分配列).
- **Reframe "what does this op touch?" → "what ops touch this point?".** Whenever
  the naive "for each op, do work" is too slow, flip the perspective. Often the dual
  framing has a single sweep that aggregates all ops together.
- **Path-sum invariant.** "Answer at v = sum of contributions along the root-to-v
  path" is one of the most reusable invariants in tree problems. If you can phrase
  your problem this way, a single DFS will likely solve it.
