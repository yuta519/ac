# Workflows

Two distinct workflows for working on AtCoder problems in this repo.

- **Workflow A** — solving a problem for the first time.
- **Workflow B** — re-solving a problem you've already committed.

Both rely on a `pre/<problem>` tagging convention and a `redo` shell script defined
in `devenv.nix`.

## Tag convention

For every solved problem, the repo holds a tag `pre/abc<n>-<letter>` pointing at
the commit *immediately before* that problem was solved. Examples:

```
pre/abc137-a → commit 5ec3c07 ("feat: ABC136-C")  ← state right before ABC137-A
pre/abc137-d → commit ...                          ← state right before ABC137-D
```

The tags are immutable bookmarks. Branches move; tags don't.

Backfilling is safe to re-run: the bulk-tag script in the project history scans for
`feat: ABC<n>-<letter>` commits and creates any missing tags.

## Branch convention

| name pattern              | role                                                       |
| ------------------------- | ---------------------------------------------------------- |
| `main`                    | canonical solutions, one commit per problem                |
| `attempt/NN-abc<n>-<l>`   | one redo attempt at a previously-solved problem            |

Attempt branches are never merged into main. They are a parallel history showing
how you'd solve the same problem at different points in your learning.

---

## Workflow A — New problem (first attempt)

```sh
# 1. Start from a clean main
git checkout main
git status                          # confirm "nothing to commit"

# 2. Download samples
ojd abc139 a

# 3. Set up the module
#    - if lib/ABC139.hs doesn't exist, create it
#    - add ABC139 to ac.cabal's exposed-modules if missing
#    - update app/Main.hs to import ABC139 and call solveA

# 4. Iterate against samples
oj t -c "runghc -ilib app/Main.hs"

# 5. When samples pass, submit on AtCoder

# 6. Tag the "before" state, then commit
git add lib/ABC139.hs app/Main.hs ac.cabal
git tag pre/abc139-a HEAD           # freeze current HEAD as pre-state
git commit -m "feat: ABC139-A"

# 7. (Optional) push
git push
git push --tags                     # if you want pre/* on the remote
```

The `git tag pre/abc139-a HEAD` line happens **before** `git commit`, so the tag
freezes the pre-solution state. After the commit, main moves forward by one and the
tag stays where it was, ready for a future redo.

If you forget step 6, no harm done — the bulk-tag script will fill in any missing
`pre/*` tags on next run.

---

## Workflow B — Redo a problem you've already solved

```sh
# 1. Start from a clean main
git checkout main
git status                          # confirm "nothing to commit"

# 2. Branch off the pre/ tag — auto-lands on a fresh attempt branch
redo abc137-d
# Output: "Started attempt/01-abc137-d (from pre/abc137-d)"
# Now: lib/ABC137.hs has no solveD, docs/solutions/ABC137-d.md doesn't exist,
#      everything is back to the state before you'd solved D.

# 3. Re-download samples (they aren't in the repo)
ojd abc137 d

# 4. Solve from scratch — solveD doesn't exist on this branch.
#    No peeking at your old solution.

# 5. Iterate against samples
oj t -c "runghc -ilib app/Main.hs"

# 6. Commit on the attempt branch (NOT on main)
git add lib/ABC137.hs app/Main.hs
git commit -m "redo: ABC137-D attempt 01"

# 7. Return to main
git checkout main
# The attempt/01-abc137-d branch persists.
```

You never merge the attempt branch into main. main has your canonical solution;
attempt branches are an independent history.

### Running `redo` again later

```sh
git checkout main
redo abc137-d
# Output: "Started attempt/02-abc137-d (from pre/abc137-d)"
```

Each invocation auto-increments the attempt number. No manual tracking.

### Comparing attempts

```sh
# old solution vs first redo
git diff main attempt/01-abc137-d -- lib/ABC137.hs

# two redos against each other
git diff attempt/01-abc137-d attempt/02-abc137-d -- lib/ABC137.hs

# list all redos for a problem
git branch --list 'attempt/*-abc137-d'
```

---

## Side-by-side cheat sheet

| step                | Workflow A (new)                          | Workflow B (redo)                          |
| ------------------- | ----------------------------------------- | ------------------------------------------ |
| starting branch     | main                                      | main                                       |
| start command       | edit cabal/Main, write module skeleton    | `redo abc<n>-<l>`                          |
| download tests      | `ojd <contest> <letter>`                  | `ojd <contest> <letter>`                   |
| iterate             | `oj t -c "runghc -ilib app/Main.hs"`      | same                                       |
| tag                 | `git tag pre/abc<n>-<l> HEAD` before commit | already exists; nothing to do            |
| commit destination  | main                                      | the attempt branch                         |
| commit message      | `feat: ABC<n>-<l>`                        | `redo: ABC<n>-<l> attempt NN`              |
| return to main      | already there                             | `git checkout main`                        |

---

## Gotchas

1. **Workflow A's tag step is easy to forget.** If you do, the tag is missing and
   you can't `redo` that problem until you backfill. Backfilling is one re-run of
   the bulk-tag script — safe to run repeatedly.

2. **Don't merge attempt branches into main.** They were branched off an old
   commit, so a merge would replay history. Use `git diff` to compare; if you
   genuinely want to replace main's solution, copy the file contents manually and
   commit normally on main.

3. **`redo` requires a clean working tree.** Same as `git checkout`. If git
   complains, `git stash` or commit your changes first.

4. **Untracked files persist across checkouts.** When you `redo` to an old commit,
   files you've created since (e.g. `docs/`) won't disappear. They're harmless —
   git knows they don't belong to that commit and ignores them. They reappear
   correctly when you return to main.
