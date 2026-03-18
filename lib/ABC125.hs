module ABC125 where

import Data.List

solveC :: [Int] -> Int
solveC ns = maximum $ zipWith gcd left right
  where
    left = scanl' gcd 0 ns
    right = tail $ scanr gcd 0 ns

solveD :: [Int] -> Int
solveD as =
  if even $ length $ filter (< 0) as
    then total
    else total - (min * 2)
  where
    total = sum $ map abs as
    min = minimum $ map abs as
