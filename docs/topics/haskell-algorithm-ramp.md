# Haskell + Algorithm Ramp-Up

This roadmap is for building confidence with both Haskell and beginner algorithm
patterns. The goal is not to rush through many problems. The goal is to make a few
core shapes feel familiar:

- reading input into useful data structures
- writing small pure `solve` functions
- using recursion without getting lost
- recognizing when to use lists, sets, maps, arrays, or queues
- explaining the idea before coding

ATC001-A is a great anchor problem because it teaches a very reusable shape:

```hs
dfs state visited
  | invalid state = False
  | already visited = False
  | goal = True
  | otherwise = try next states
```

## How to practice each problem

For each problem, use this loop:

1. Read the statement and samples.
2. Write down the state you need. For DFS, this might be `(x, y)` or `node`.
3. Write the type of `solve` before writing the body.
4. Solve with simple data structures first.
5. After passing samples, write 3-5 notes:
   - What was the state?
   - What were the transitions?
   - What stopped infinite loops or repeated work?
   - What Haskell syntax did you learn?

If stuck for 30-45 minutes, read the editorial, then close it and reimplement from
memory. That is still good practice.

## Stage 1: Haskell input and small pure functions

These build comfort with `getLine`, `words`, `map read`, lists, `if`, guards, and
small `solveA` functions.

| # | problem | link | practice focus |
| - | ------- | ---- | -------------- |
| 1 | ABC081-A: Placing Marbles | https://atcoder.jp/contests/abc081/tasks/abc081_a | Count characters in a string. |
| 2 | ABC081-B: Shift only | https://atcoder.jp/contests/abc081/tasks/abc081_b | Repeated operation, recursion or loop-like thinking. |
| 3 | ABC086-A: Product | https://atcoder.jp/contests/abc086/tasks/abc086_a | Tiny pure function from parsed integers. |
| 4 | ABC088-B: Card Game for Two | https://atcoder.jp/contests/abc088/tasks/abc088_b | Sorting, alternating turns, list processing. |
| 5 | ABC083-B: Some Sums | https://atcoder.jp/contests/abc083/tasks/abc083_b | Generate candidates, filter, sum. |

Haskell moves to practice:

```hs
map read . words
filter predicate xs
sum xs
sort xs
reverse xs
```

## Stage 2: Recursion and exhaustive search

These problems help you get used to trying possibilities. This is the same mental
family as DFS, but usually with smaller state.

| # | problem | link | practice focus |
| - | ------- | ---- | -------------- |
| 1 | ABC085-C: Otoshidama | https://atcoder.jp/contests/abc085/tasks/abc085_c | Brute force with nested loops/list comprehensions. |
| 2 | ABC049-C: Daydream | https://atcoder.jp/contests/abc049/tasks/arc065_a | Recursive string matching or reverse-and-consume trick. |
| 3 | ABC087-B: Coins | https://atcoder.jp/contests/abc087/tasks/abc087_b | Count valid combinations. |
| 4 | ABC045-C: Many Formulas | https://atcoder.jp/contests/abc045/tasks/arc061_a | Enumerate splits/patterns. |

Haskell moves to practice:

```hs
[(a, b, c) | a <- [0..n], b <- [0..n], c <- [0..n]]
any predicate xs
find predicate xs
```

## Stage 3: Grid DFS, visited sets, and reachability

This is the direct continuation from ATC001-A.

> If the `visited` set gives you trouble in Haskell — passing it around correctly, or
> getting TLE on a search that looks right — read
> [`threading-state-through-recursion.md`](threading-state-through-recursion.md). It
> covers the "mutable global vs. threaded state" gap head-on and has its own practice
> ladder (#1 ATC001-A → #5 ABC138-D).

| # | problem | link | practice focus |
| - | ------- | ---- | -------------- |
| 1 | ATC001-A: 深さ優先探索 | https://atcoder.jp/contests/atc001/tasks/dfs_a | Grid DFS, `visited`, four directions. |
| 2 | ABC007-C: 幅優先探索 | https://atcoder.jp/contests/abc007/tasks/abc007_3 | BFS shortest path on a grid. |
| 3 | AGC033-A: Darker and Darker | https://atcoder.jp/contests/agc033/tasks/agc033_a | Multi-source BFS. |
| 4 | ABC088-D: Grid Repainting | https://atcoder.jp/contests/abc088/tasks/abc088_d | BFS distance plus counting cells. |

What to notice:

- DFS answers "can I reach the goal?"
- BFS answers "what is the shortest number of steps?"
- `Set (Int, Int)` is simple and good for learning.
- For larger or faster solutions, arrays/vectors are better than repeated `!!`.

Useful DFS skeleton:

```hs
dfs :: Int -> Int -> Set.Set (Int, Int) -> Bool
dfs x y visited
  | outOfBounds = False
  | wall = False
  | Set.member (x, y) visited = False
  | goal = True
  | otherwise =
      let visited' = Set.insert (x, y) visited
       in dfs (x + 1) y visited'
       || dfs (x - 1) y visited'
       || dfs x (y + 1) visited'
       || dfs x (y - 1) visited'
```

Useful direction list:

```hs
dirs :: [(Int, Int)]
dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
```

## Stage 4: Sets, maps, and frequency counting

These train the idea of storing what you have seen. That is closely related to
`visited` in DFS.

| # | problem | link | practice focus |
| - | ------- | ---- | -------------- |
| 1 | ABC085-B: Kagami Mochi | https://atcoder.jp/contests/abc085/tasks/abc085_b | Count distinct values with `Set`. |
| 2 | ABC155-C: Poll | https://atcoder.jp/contests/abc155/tasks/abc155_c | Frequency count with `Map`. |
| 3 | ABC137-C: Green Bin | https://atcoder.jp/contests/abc137/tasks/abc137_c | Normalize strings, count pairs. |
| 4 | ABC166-C: Peaks | https://atcoder.jp/contests/abc166/tasks/abc166_c | Graph-ish comparisons and filtering. |

Haskell moves to practice:

```hs
Set.fromList xs
Map.insertWith (+) key 1 mp
Map.toList mp
```

## Stage 5: Prefix sums and "do work once"

These are important because many algorithms are about avoiding repeated work.

| # | problem | link | practice focus |
| - | ------- | ---- | -------------- |
| 1 | ABC037-C: 総和 | https://atcoder.jp/contests/abc037/tasks/abc037_c | Basic prefix sums. |
| 2 | ABC084-D: 2017-like Number | https://atcoder.jp/contests/abc084/tasks/abc084_d | Precompute answers, answer many queries. |
| 3 | ABC014-C: AtColor | https://atcoder.jp/contests/abc014/tasks/abc014_3 | Imos/difference array. |
| 4 | ABC035-C: オセロ | https://atcoder.jp/contests/abc035/tasks/abc035_c | Difference array with parity/toggle. |

Phrase to remember:

> If many queries ask about the same world, build the world once.

## Stage 6: Tree DFS

Once grid DFS feels okay, move to trees. The same recursion appears again, but the
neighbors come from an adjacency list instead of four grid directions.

| # | problem | link | practice focus |
| - | ------- | ---- | -------------- |
| 1 | ABC126-D: Even Relation | https://atcoder.jp/contests/abc126/tasks/abc126_d | DFS carrying accumulated distance parity. |
| 2 | ABC138-D: Ki | https://atcoder.jp/contests/abc138/tasks/abc138_d | Tree DFS plus accumulated additions. |
| 3 | ABC146-D: Coloring Edges on Tree | https://atcoder.jp/contests/abc146/tasks/abc146_d | Tree traversal with parent/edge state. |
| 4 | ABC209-D: Collision | https://atcoder.jp/contests/abc209/tasks/abc209_d | Tree depth parity after preprocessing. |

Tree DFS shape:

```hs
dfs node parent acc = doSomethingHere
  where
    children = filter (/= parent) (adj ! node)
```

The key difference from grid DFS:

- In a tree, passing `parent` is often enough to avoid going backward.
- In a general graph or grid, use `visited`.

## Suggested 4-week plan

| week | target |
| ---- | ------ |
| 1 | Stage 1 + Stage 2. Get comfortable writing small `solve` functions. |
| 2 | ATC001-A, then ABC007-C. Compare DFS and BFS. |
| 3 | Sets/maps/frequency problems. Treat them as "visited, but for data." |
| 4 | Prefix sums, then ABC126-D or ABC138-D if you feel ready. |

Do not worry if this takes longer than four weeks. Re-solving old problems is often
more valuable than forcing new ones.

## Personal checklist before moving on

You are ready for the next stage when you can answer these without looking:

- What is the type of my `solve` function?
- What data structure represents the problem state?
- What are the transitions?
- What makes recursion stop?
- What prevents repeated work?
- Is this a reachability problem, shortest-path problem, counting problem, or
  precomputation problem?

When those questions become natural, the code gets much less mysterious.
