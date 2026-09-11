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

