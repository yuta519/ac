module ABC143 where

import Data.List (tails)

solveA :: Int -> Int -> Int
solveA a b
  | a - b * 2 > 0 = a - b * 2
  | otherwise = 0

solveB :: [Int] -> Int
solveB ds = sum [x * y | (x : ys) <- tails ds, y <- ys]

solveC :: Int -> String -> Int
solveC cur (x : y : zs) = if x == y then solveC (cur - 1) (y : zs) else solveC cur (y : zs)
solveC cur _ = cur
