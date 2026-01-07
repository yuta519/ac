# ac

## Overview
This is the author's private project to practic Haskell and work on [AtCoder](https://atcoder.jp/) problems with Haskell. 

## Requirements
- Nix
- [devenv.sh](https://devenv.sh/getting-started/)

## Run main 
```bash
$ runghc -ilib app/Main.hs

or

$ cabal build
$ cabal run ac
```

## Test with online-judege-tools/oj
- Download test cases
```bash
# This URL is an example
$ oj download https://atcoder.jp/contests/abc166/tasks/abc166_c
```
- Run tests locally
```bash
$ oj t -c " runghc -ilib app/Main.hs"
```
- Once you finished the problem, please remove test files under `test` directory
```bash
$ rm test/*
```
