# ac (AtCoder)

## Overview
This repository is the author's private project to work on [AtCoder](https://atcoder.jp/) problems with Haskell. You can find AtCoder problems from this [website](https://kenkoooo.com/atcoder/#/table/)


## Requirements
- [Nix](https://nixos.org/)
- [devenv.sh](https://devenv.sh/getting-started/)


## Run with online-judge-tools/oj
You can run your codes with test cases which AtCoder prepares as samples. You need to install [oj](https://github.com/online-judge-tools/oj) in advance.
- Download test cases
```bash
$ oj download https://atcoder.jp/contests/abc166/tasks/abc166_c
```
- Run tests locally
```bash
$ oj t -c "runghc -ilib app/Main.hs"
```
- Once you finished the problem, please remove test files under `test` directory
```bash
$ rm test/*
```
## Run main 
```bash
$ runghc -ilib app/Main.hs
or
$ cabal build
$ cabal run ac
```

## Docs
Notes and write-ups live under `docs/`:

- [`docs/workflows.md`](docs/workflows.md) — the two workflows for solving a new problem vs. redoing a solved one (tag/branch conventions, `redo` script).
- [`docs/solutions/`](docs/solutions/) — per-problem walkthroughs of how to arrive at the solution (not just the code). Start from [`0-template.md`](docs/solutions/0-template.md) when adding a new one.
- [`docs/topics/`](docs/topics/) — cross-problem notes on techniques, concepts, and roadmaps.

### Topics
- [Haskell + algorithm ramp-up](docs/topics/haskell-algorithm-ramp.md) — the practice loop and staged problem roadmap.
- [Threading state through pure recursion](docs/topics/threading-state-through-recursion.md) — why a `visited` set doesn't work like a mutable one, and how to thread it.
- [Roadmap: building up to ABC138-D](docs/topics/tree-dfs-and-prefix-sums.md) — tree DFS + prefix sums, decomposed by skill.
- [Knights and knaves: hypothesize-a-world, then verify](docs/topics/knights-and-knaves-consistency.md) — truth-teller/liar logic; propose-and-verify over propagate-and-deduce.
- [GCD, LCM, and divisibility](docs/topics/gcd-lcm-and-divisibility.md) — the prime-exponent view, `gcd × lcm = a × b`, and the two overflow traps.

### Solutions
| Problem | Theme |
|---|---|
| [ABC137-D](docs/solutions/ABC137-d.md) | scheduling / greedy with a heap |
| [ABC138-D](docs/solutions/ABC138-d.md) | tree DFS + prefix sums (Imos on a tree) |
| [ABC139-C](docs/solutions/ABC139-c.md) | longest non-increasing run; adjacent comparisons, `!!` is O(n) |
| [ABC142-D](docs/solutions/ABC142-d.md) | pairwise-coprime ⇒ count distinct primes of `gcd(A,B)` |
| [ABC143-D](docs/solutions/ABC143-d.md) | fix two sides, binary-search the third |
| [ABC144-D](docs/solutions/ABC144-d.md) | tilt geometry; two `atan` cases, radians → degrees |
| [ABC146-C](docs/solutions/ABC146-c.md) | search space collapses from 1e9 candidates to 10 digit-bands |
| [ABC147-C](docs/solutions/ABC147-c.md) | N ≤ 15 ⇒ enumerate all 2^N assignments, then verify |
| [ABC150-C](docs/solutions/ABC150-c.md) | N ≤ 8 ⇒ enumerate all N!; `permutations` is not sorted |
