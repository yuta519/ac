# ABC144-D — How to think about this problem

Problem: https://atcoder.jp/contests/abc144/tasks/abc144_d

This document walks through *how to arrive at the solution*, not the final code — the two
ratios and the guard are left to finish myself. It records the geometry, why one linear
formula can't work, and the floating-point pitfalls.

## 1. Read the constraints first

- a, b, x integers; x up to a²b (the full volume). a, b up to 100.
- Output a real number (the tilt angle in degrees), accepted within an absolute/relative
  error of ~1e-6.

There's no size/TLE concern here — it's O(1) arithmetic. The constraint that *matters*
is the **1e-6 accuracy tolerance**, which dictates the floating-point type (see §6).

## 2. Reframe the problem in your own words

A square-base bottle (`a × a` base, height `b`, volume `a²b`) holds water volume `x`.
Tilt it about one bottom edge until the water is on the verge of spilling. Report the
tilt angle θ.

Naive framing: "angle scales linearly with how full it is" → something like
`(a²b − x)/a²b × 90`. **This is wrong** — the water/air boundary is a *plane*, and the
solid it cuts changes shape depending on how full the bottle is. The relationship between
volume and angle is an **`atan`**, not linear.

The reframe — the key move:

> The empty (air) region, or the water region, forms a **triangular prism** whose
> cross-section is a right triangle. Which triangle depends on whether the water is at
> least half full. Equate the prism's volume to the known volume, solve for `tanθ`, take
> `atan`.

## 3. Why two cases, not one formula

Tilting to the spill point produces two geometric regimes:

- **Case A — water at least half full (`x ≥ a²b / 2`):** the water still covers the whole
  base; the *air* is a wedge at the top. Its cross-section triangle has legs along the
  top and the far wall.
- **Case B — water less than half full (`x < a²b / 2`):** the water surface drops below
  the top edge; the *water* itself is a wedge against the bottom and near wall.

A single linear formula can't span both because the cross-section triangle swaps which
two faces it touches at the half-full threshold. The guard is `2x` vs `a²b` (compare
doubled to stay in integers and avoid a `/2` rounding question).

### Visualizing it (side view)

Look at the `a × a` cross-section; the prism runs depth `a` into the page. Tilt about the
**bottom-right edge** until water reaches the top-right lip.

The upright bottle — square base `a`, height `b`, full volume `a²·b`:

```
        a
    ┌───────┐  ─┐
    │       │   │
    │       │   │  b   (height)
    │       │   │
    └───────┘  ─┘
```

**Case A — water at least half full (`x ≥ a²b/2`): an AIR wedge at the top.**
Water still covers the whole base; the empty triangle sits top-left.

```
         a
    ┌──────────┐
    │∙∙∙╱      │   ∙ = air (triangle)
    │∙∙╱       │   legs:  horizontal = a
    │∙╱        │          vertical   = a·tanθ
    │╱─────────│
    │~~~~~~~~~~│   ~ = tilted water surface
    │██████████│   █ = water
    └──────────┘
```

`air = ½·a·(a·tanθ)·a = a³tanθ/2 = a²b − x`  →  `θ = atan( 2(a²b−x)/a³ )`

**Case B — water less than half full (`x < a²b/2`): a WATER wedge at the bottom.**
The surface drops below the top edge; the water itself is the triangle, bottom-right.

```
         a
    ┌──────────┐
    │∙∙∙∙∙∙∙∙∙∙│   ∙ = air
    │∙∙∙∙╲∙∙∙∙∙│   ~ = tilted water surface
    │∙∙∙∙∙╲~~~~│
    │██████╲∙∙∙│   █ = water (triangle)
    │███████╲∙∙│   legs:  vertical   = b
    └──────────┘          horizontal = L = 2x/(ab)
              L
```

`x = ½·L·b·a` → `L = 2x/(ab)`, and `tanθ = b/L`  →  `θ = atan( a·b²/(2x) )`

**Pouring water out (decrease `x`), tilt held at the spill point** — the triangle
migrates from top to bottom, passing through the corner-to-corner threshold:

```
  x large            x = a²b/2           x small
  (Case A)          (threshold)          (Case B)
 ┌────────┐         ┌────────┐          ┌────────┐
 │∙╱      │         │╲       │          │∙∙∙∙∙∙∙∙│
 │╱───────│         │∙╲      │          │∙∙∙∙∙╲∙∙│
 │████████│         │∙∙╲~~~~~│          │██████╲∙│
 │████████│         │███╲████│          │███████╲│
 └────────┘         └────────┘          └────────┘
  air triangle      surface runs         water triangle
  shrinks up        corner-to-corner     shrinks down
```

At the threshold the surface runs bottom-right to top-left, giving `tanθ = b/a` from
**both** formulas — the continuity check in §4.

## 4. Concrete algorithm (derivation)

Let θ be the tilt angle.

**Case A — air wedge (`x ≥ a²b / 2`).**
The air prism runs the full depth `a`. Cross-section right triangle: horizontal leg `a`,
vertical leg `a·tanθ`. Air volume:

```
air = ½ · a · (a·tanθ) · a = a³·tanθ / 2
```

Air volume is also `a²b − x`. Equate:

```
a³·tanθ / 2 = a²b − x
tanθ = 2(a²b − x) / a³
θ    = atan( 2(a²b − x) / a³ )
```

**Case B — water wedge (`x < a²b / 2`).**
Water prism against bottom + wall, depth `a`. Cross-section right triangle: vertical leg
`b` (full height), horizontal leg `L`. Water volume:

```
x = ½ · L · b · a   ⟹   L = 2x / (a·b)
```

The tilt angle satisfies `tanθ = b / L`:

```
tanθ = b / L = a·b² / (2x)
θ    = atan( a·b² / (2x) )
```

**Convert radians → degrees** (`atan` returns radians; the answer is in degrees):

```
degrees = θ · 180 / pi
```

### Worked check — sanity at the boundary

At exactly half full (`x = a²b/2`), both formulas should agree:

- Case A: `tanθ = 2(a²b − a²b/2)/a³ = 2·(a²b/2)/a³ = a²b/a³ = b/a`.
- Case B: `tanθ = a·b²/(2·a²b/2) = a·b²/(a²b) = b/a`. ✓

Both give `tanθ = b/a` — the diagonal from one bottom edge to the opposite top edge, as
expected. This agreement is the check that the two cases are stitched correctly.

## 5. Check the complexity

O(1) arithmetic. No loops. Trivially within budget.

## 6. Spot-check accuracy and types — the real gotcha

- **Use `Double`, not `Float`.** `Float` is 32-bit (~7 significant digits); the 1e-6
  tolerance can fail on it. `Double` (64-bit, ~15 digits) is the AtCoder default for
  real-valued output. This was the first bug: `solveD :: ... -> Float`.
- **`fromIntegral` *before* multiplying.** Convert `a`, `b`, `x` to `Double` before
  forming `a³` etc., and note `a²b` for a=b=100 is 1e6 — fits `Int`, but do the division
  in `Double`.
- **`/` needs `Fractional`.** `Int` has no `/` (that's `div`); mixing `Int` and `/`
  gives *No instance for (Fractional Int)*. Convert first. (Second bug hit.)
- **`let` vs `where`.** In a `where` block, bind directly (`where v = …`) — no `let`.
  `let … in …` is the expression-level form. (Third bug hit.)

## Current state — wrong formula (compiles, but not the answer)

```haskell
solveD :: Int -> Int -> Int -> Float
solveD a b x = (volume - fromIntegral x) / volume * 90.0
  where volume = fromIntegral (a * a * b)
```

This is a *linear* interpolation and single-case — it ignores the `atan` geometry and the
half-full split. It compiles (syntax fixed) but produces wrong angles.

## The remaining step — TODO

Rewrite `solveD` with:

1. a guard on `2*x` vs `a*a*b` (half-full test),
2. `atan` of the correct ratio per case (from §4),
3. a `degrees rad = rad * 180 / pi` helper,
4. return type `Double`, all inputs `fromIntegral`-converted before the math.

```haskell
solveD :: Int -> Int -> Int -> Double
solveD a b x
  | 2 * x >= a * a * b = degrees (atan ( ... ))   -- case A: air wedge
  | otherwise          = degrees (atan ( ... ))   -- case B: water wedge
  where
    degrees rad = rad * 180 / pi
    -- fromIntegral a, b, x as needed
```

## 7. Lessons to carry forward

- **A moving planar boundary ⇒ case split on the geometry.** When a cut plane changes
  which faces it intersects, one closed-form formula can't cover all inputs. Find the
  threshold (here, half full) and derive each regime separately.
- **Volume↔angle is `atan`, not linear.** Equate the known volume to the prism volume
  expressed via `tanθ`, then invert with `atan`. Linear "percentage × 90" is a tempting
  trap.
- **`atan` returns radians — convert to degrees** with `× 180 / pi` when the problem asks
  for degrees.
- **For real-valued output under a 1e-6 tolerance, use `Double`, never `Float`.** And
  `fromIntegral` before dividing — `Int` has no `/`.
- **Check case-boundary agreement.** Both branches must give the same angle at the
  threshold (here `tanθ = b/a`); that equality is a free correctness test.
</content>
