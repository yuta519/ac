module ABC137 where

import Data.List (group, sort)

solveA :: Int -> Int -> Int
solveA a b = maximum [a + b, a - b, a * b]

solveB :: Int -> Int -> [Int]
solveB k x = [x - k + 1 .. x + k - 1]

solveC :: [String] -> Int
solveC ss = sum [k * (k - 1) `div` 2 | s <- ss', let k = length s]
  where
    ss' = group $ sort [sort s | s <- ss]
