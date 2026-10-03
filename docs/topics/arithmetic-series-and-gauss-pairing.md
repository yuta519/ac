# Arithmetic series and Gauss's pairing trick: replace a summing loop with one formula

This note is about the **sum of evenly spaced numbers**, the idea that came up in ABC154-D when
computing each die's expected value. A loop over `1..p` costs `p` steps; the closed form costs one.

Any time a loop adds up values that step by a fixed amount, reach for this first.

---

## The pairing trick

Write the numbers forwards, then backwards underneath, and add each column:

```
forwards:    1    2    3    4    5
backwards:   5    4    3    2    1
            ───  ───  ───  ───  ───
column sum:  6    6    6    6    6
```

Every column is the same, `1 + p`, because the top row goes up by one while the bottom row goes
down by one. There are `p` columns, and both rows together count every number twice:

```
2 × (1 + 2 + … + p) = p × (1 + p)
    1 + 2 + … + p   = p(1 + p) / 2          -- p = 5:  5 × 6 / 2 = 15
```

The name comes from the story of a young Gauss adding 1 to 100 by pairing 1+100, 2+99, …:
50 pairs of 101, total 5050.

## The general formula

The trick never used the fact that the numbers start at 1 or step by 1. For any arithmetic series:

```
sum   = (number of terms) × (first + last) / 2
terms = (last − first) / step + 1
```

Example, `3 + 7 + 11 + 15`: terms `= (15 − 3) / 4 + 1 = 4`, sum `= 4 × (3 + 15) / 2 = 36`.

`1 + 2 + … + n = n(n+1)/2` is the special case; these values (1, 3, 6, 10, 15, …) are the
**triangular numbers**.

## Worked examples

Each one checked against `sum` of the list.

| Series | Terms | First + last | Sum |
|---|---|---|---|
| `1 + 2 + … + 100` | 100 | 101 | `100 × 101 / 2 = 5050` |
| `2 + 4 + … + 100` (evens) | `(100 − 2) / 2 + 1 = 50` | 102 | `50 × 102 / 2 = 2550` |
| `1 + 3 + … + 99` (odds) | `(99 − 1) / 2 + 1 = 50` | 100 | `50 × 100 / 2 = 2500` |
| `10 + 9 + … + 1` (counting down) | `(1 − 10) / (−1) + 1 = 10` | 11 | `10 × 11 / 2 = 55` |
| `20 + 21 + … + 30` (a range) | `30 − 20 + 1 = 11` | 50 | `11 × 50 / 2 = 275` |

**Odd count, middle term left over?** With 5 numbers there's no partner for the middle `3`. The
two-row picture still works: the middle column is `3 + 3 = 6`, the same as every other column.

**Odd numbers give squares.** `1 + 3 + … + (2n − 1)` has `n` terms and `first + last = 2n`, so the
sum is `n × 2n / 2 = n²`: 1, 4, 9, 16, 25, 36.

**Multiples of `k` up to `N`.** The multiples are `k, 2k, …, mk` with `m = N \`div\` k`. That's
`k × (1 + 2 + … + m)`:

```
multiples of 3 up to 100:  m = 33,  3 × (33 × 34 / 2) = 1683
```

**Counting pairs.** With `n` people, person 2 pairs with 1 person before them, person 3 with 2, and
so on, so the number of pairs is `0 + 1 + … + (n − 1) = n(n − 1) / 2`:

```
5 people:  0 + 1 + 2 + 3 + 4 = 5 × 4 / 2 = 10 pairs
```

This is the same count as "number of `(i, j)` with `i < j`", which comes up whenever a brute force
loops over all pairs. It tells you how many steps that loop takes.

## Average = midpoint

Divide the sum by the number of terms and the count cancels:

```
average = (first + last) / 2
```

Evenly spaced numbers are balanced around their midpoint. For a die with faces `1..p`:

```
E = (1 + p) / 2

p=1 → 1.0    p=2 → 1.5    p=4 → 2.5    p=5 → 3.0
```

For even `p` the midpoint falls between two faces (`p = 4` → 2.5, between 2 and 3).

## In Haskell

```haskell
-- O(n): fine for small n, too slow inside another loop
sum [1 .. n]

-- O(1)
n * (n + 1) `div` 2
```

`n * (n + 1)` is always even (one of two neighbours is even), so `div` here is exact.

## Trap 1: integer division on the average

The *sum* is always an integer; the *average* often isn't.

```
(1 + p) `div` 2                          →  [1, 1, 2, 3]          ✗  for p = 1, 2, 4, 5
fromIntegral (1 + p) / 2 :: Double       →  [1.0, 1.5, 2.5, 3.0]  ✓
```

`div` rounds down silently. If the answer can be fractional, convert with `fromIntegral` and use `/`:

```haskell
-- ✗ both divisions are integer; the second one rounds 3/2 down to 1
[p * (p + 1) `div` 2 `div` p | p <- ps]

-- ✓ one fractional division
[fromIntegral (p + 1) / 2 | p <- ps] :: [Double]
```

`/` only works on fractional types like `Double`, and Haskell never converts `Int` to `Double`
on its own, so `fromIntegral` is required.

## Trap 2: overflow in `n * (n + 1)`

The product can overflow even when the answer fits. Measured at `n = 4 × 10⁹`:

```
n * (n + 1) `div` 2       →  -1223372034854775808    ✗  intermediate ≈ 1.6 × 10¹⁹ > maxBound
halve the even factor     →   8000000002000000000    ✓
Integer                   →   8000000002000000000    ✓
```

Halving the even factor first keeps every intermediate no bigger than the answer:

```haskell
triSafe n
  | even n    = (n `div` 2) * (n + 1)
  | otherwise = n * ((n + 1) `div` 2)
```

`Int` tops out near `9.2 × 10¹⁸`, so the plain form breaks around `n ≈ 3 × 10⁹`. Below that it's safe.

## Where this sits among the problems already solved

| Concept | Problem |
|---|---|
| expected value of a uniform die `1..p` | ABC154-D |

## Lessons to carry forward

- **`sum = terms × (first + last) / 2`.** Derive it from the pairing picture instead of memorising.
- **Average of evenly spaced numbers = `(first + last) / 2`.** No loop, no sum.
- **Count terms with `(last − first) / step + 1`.** The `+ 1` is the usual off-by-one.
- **Sum is exact in `Int`; the average needs `Double`.**
- **Watch `n * (n + 1)` past `n ≈ 3 × 10⁹`.** Halve the even factor first, or use `Integer`.

---

Related: [[tree-dfs-and-prefix-sums]] for the other way to avoid re-adding numbers,
[[haskell-algorithm-ramp]] for the general practice loop.
