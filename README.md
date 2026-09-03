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

