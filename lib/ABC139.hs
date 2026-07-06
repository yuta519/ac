module ABC139 where

import Data.Array (Array, listArray, (!))

solveA :: String -> String -> Int
solveA s t = sum [1 | i <- [0 .. 2], s !! i == t !! i]

solveB :: Int -> Int -> Int
solveB a b = go 0
  where
    go cur
      | 1 + (a - 1) * cur < b = go (cur + 1)
      | otherwise = cur

-- Longest run of consecutive non-increasing steps, counted in moves.
-- `l` anchors the start of the current run, `r` is the cursor; `r - l - 1` is
-- the move count of the run [l, r). Same algorithm as before, but indexing an
-- Array (O(1)) instead of a list (`!!` is O(index)), so it's O(N) not O(N^2).
solveC :: [Int] -> Int
solveC hs = go 0 1 0
  where
    n = length hs
    arr :: Array Int Int
    arr = listArray (0, n - 1) hs
    go l r cur
      | r >= n = max (r - l - 1) cur
      | arr ! (r - 1) >= arr ! r = go l (r + 1) (max (r - l - 1) cur)
      | otherwise = go r (r + 1) (max (r - l - 1) cur)

solveD :: Int -> Int
solveD n = n * (n - 1) `div` 2
