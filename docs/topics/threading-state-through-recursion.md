# Threading state through pure recursion (the "visited" problem)

This note is about a specific wall on **ATC001-A**: a Haskell grid DFS that looks
right but is either wrong or too slow. The gap is not about DFS itself — it's about
*how mutable state becomes pure state* in Haskell.

Write this one into muscle memory. It comes back for **every** grid/graph search,
and again (in disguise) for BFS, flood fill, and DP.

---

## The mental trap

In Python you reach for a shared mutable set:

```python
visited = set()                 # one set, everyone mutates it

def dfs(x, y):
    if out_of_bounds(x, y): return False
    if grid[x][y] == '#':   return False
    if (x, y) in visited:   return False
    if grid[x][y] == 'g':   return True
    visited.add((x, y))         # <-- mutation everyone sees
    return dfs(x+1,y) or dfs(x-1,y) or dfs(x,y+1) or dfs(x,y-1)
```

`visited.add` mutates the *one* set. Every branch — and every later sibling branch —
sees the addition. Each cell is entered once. Fast.

### Why the naive Haskell port is broken

```haskell
dfs x y visited
  | ... = False
  | otherwise =
      let visited' = Set.insert (x, y) visited
       in dfs (x+1) y visited' || dfs (x-1) y visited'
       || dfs x (y+1) visited' || dfs x (y-1) visited'
```

`Set.insert` does **not** mutate — it returns a *new* set and leaves `visited`
untouched. So all four calls get the **same** `visited'`. When the "down" branch
explores 300 cells and returns `False`, those 300 cells are **forgotten**: the "up"
branch starts as if it had never seen them.

> The set only blocks revisits *along one path*, never *across sibling branches*.

Result: cells get re-entered through many paths. Passes the tiny samples, **TLE on a
full 500×500 grid**. This is the bug — and "just make `visited` a global" doesn't fix
it, because a top-level Haskell binding is an immutable value; `Set.insert` still
can't change it. (You *can* get true mutation via `IORef`/`ST`/mutable arrays, but
that drags you into a monad — overkill here and a detour from the pure-recursion shape
we're drilling.)

---

## The fix: thread the state

Pure code can't share *one mutable* set, so instead each call **returns the set it
ended up with**, and we **feed that into the next call**. The state is "shared" by
being passed hand-to-hand.

Step 1 — change the return type so the set comes back out:

```haskell
explore :: (Int, Int) -> Set (Int,Int) -> (Bool, Set (Int,Int))
--                                          ^reached g?  ^visited AFTER this call
```

Step 2 — base cases hand the set straight back, unchanged:

```haskell
| not (inBounds (x,y))      = (False, visited)
| cell == '#'              = (False, visited)
| Set.member (x,y) visited = (False, visited)
| cell == 'g'              = (True,  visited)
```

Step 3 — the recursive case can no longer use `||` (that's `Bool → Bool → Bool`, but
we now carry a pair). Walk the neighbours one at a time, **threading the set forward**:

```haskell
| otherwise = go neighbors (Set.insert (x,y) visited)
  where
    go []     v = (False, v)            -- out of neighbours, no goal
    go (n:ns) v = case explore n v of
        (True,  v') -> (True,  v')      -- found it — stop, return the set
        (False, v') -> go ns v'         -- not here; KEEP v' for the next neighbour
```

**The whole fix is the `v'` (not `v`) on the last line.** `go ns v'` gives the next
neighbour the set that *includes everything the failed branch explored*. Write `v`
there and you're back to the original bug.

---

## Diagram: same vs threaded `visited`

Naive `||` chain — every branch forks from the SAME pre-branch set `S`:

```
                 explore (x,y),  visited = S
                 (insert self → S₀)
        ┌───────────┬───────────┬───────────┐
        ▼           ▼           ▼           ▼
     down(S₀)    up(S₀)     left(S₀)    right(S₀)
        │           │
   visits 300       └─ re-walks the SAME 300 cells:
   cells, fails        they were never recorded in up's copy
                       → repeated work → exponential blowup
```

Threaded — each branch's output set flows into the NEXT branch:

```
   go [down,up,left,right]  S₀
        │
        ▼
     down(S₀)  ──returns──▶ (False, S₁)   S₁ = S₀ + down's 300 cells
                                  │
                                  ▼
                              up(S₁)  ──returns──▶ (False, S₂)
                                  │   (up hits down's cells → Set.member True → stops at once)
                                  ▼
                             left(S₂) ──▶ (False, S₃)
                                  │
                                  ▼
                            right(S₃) ──▶ (?, S₄)

   Set grows monotonically: S₀ ⊆ S₁ ⊆ S₂ ⊆ S₃ ⊆ S₄
   Each cell inserted once  ⇒  each cell processed once.
```

The threaded set does exactly what Python's mutable global did — it just travels
*through return values* instead of *through mutation*.

---

## The pattern, named

> **When you'd reach for a mutable variable in an imperative language, in pure
> Haskell you return the new state and pass it forward.** A short-circuiting fold
> (`go` above) is the workhorse for threading it across several sub-calls.

You'll see the same shape as:
- `foldl'` over a list, accumulator = "what I've seen / built so far"
- the `State` monad (which is literally this threading, hidden behind `>>=`)
- BFS, where the threaded thing is a *queue* plus a visited set (see ABC007-C)

State-threading vs **memoization**: both avoid repeated work, but they're different.
Threading carries "what I've *seen*" to prune. Memoization caches "what I've
*computed*" (an answer per input) to reuse. `visited` is the former.

---

## Practice ladder — make threading automatic

Do these in order. For each: write the **type of the recursive helper first** (what
goes in, what comes out), *then* the body. If the return type isn't a pair/accumulator,
ask "where does my state live?"

| # | problem | link | what to thread |
| - | ------- | ---- | -------------- |
| 1 | ATC001-A: 深さ優先探索 | https://atcoder.jp/contests/atc001/tasks/dfs_a | `visited` set through a 4-way DFS. **This doc's problem — nail it first.** |
| 2 | ABC007-C: 幅優先探索 (BFS) | https://atcoder.jp/contests/abc007/tasks/abc007_3 | A *queue* + `visited`/dist map. DFS recursion → explicit frontier. The natural next step after #1. |
| 3 | ABC088-D: Grid Repainting | https://atcoder.jp/contests/abc088/tasks/abc088_d | BFS shortest path, then count cells. Reuse #2's skeleton. |
| 4 | AGC033-A: Darker and Darker | https://atcoder.jp/contests/agc033/tasks/agc033_a | Multi-source BFS — seed the queue with many starts. Forces arrays over `Set`/`!!` for speed. |
| 5 | ABC138-D: Ki | https://atcoder.jp/contests/abc138/tasks/abc138_d | Tree DFS threading an accumulated value down to children. Same threading, payload is a number not a set. |

### Calibration

- **#1 feels hard:** right level. Re-solve it from scratch a day later, no peeking.
- **Stuck >30 min:** read the editorial, close it, reimplement from memory.
- **`Set` + `!!` TLEs (it will around #4):** switch the grid to `Data.Array` for O(1)
  lookups and consider an unboxed mutable array in `ST` for visited. That's the
  "graduate" version — don't reach for it until `Set` actually times out.

### Self-check before moving on

- What is the type of my recursive helper? Where does the state appear in it?
- Which argument is "carried in" and which result is "handed back out"?
- In my short-circuit fold, am I passing the *updated* state to the next sibling
  (`go ns v'`), or accidentally the old one (`go ns v`)?
- Could I rewrite this with `foldl'` or the `State` monad? (You don't have to — but
  if you *see* that you could, the pattern has landed.)
