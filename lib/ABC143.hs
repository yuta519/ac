module ABC143 where

import Data.List (tails)

solveA :: Int -> Int -> Int
solveA a b
  | a - b * 2 > 0 = a - b * 2
  | otherwise = 0

solveB :: [Int] -> Int
solveB ds = sum [x * y | (x : ys) <- tails ds, y <- ys]
