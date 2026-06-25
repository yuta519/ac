# ac (AtCoder)

## Overview
This is the author's practice project to practice Haskell and work on [AtCoder](https://atcoder.jp/) problems with Haskell. 
You can find AtCoder problems [here](https://kenkoooo.com/atcoder/#/table/) 


## Requirements
- [Nix](https://nixos.org/)
- [devenv.sh](https://devenv.sh/getting-started/)

## Run main 
```bash
$ runghc -ilib app/Main.hs
or
$ cabal build
$ cabal run ac
```

## Test with online-judge-tools/oj
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

## Docs
Notes and write-ups live under `docs/`:

- [`docs/workflows.md`](docs/workflows.md) — the two workflows for solving a new problem vs. redoing a solved one (tag/branch conventions, `redo` script).
- [`docs/solutions/`](docs/solutions/) — per-problem walkthroughs of how to arrive at the solution (not just the code). Start from [`0-template.md`](docs/solutions/0-template.md) when adding a new one.
- [`docs/topics/`](docs/topics/) — cross-problem notes on techniques and roadmaps (e.g. tree DFS + prefix sums, [threading `visited` state through recursion](docs/topics/threading-state-through-recursion.md)).
