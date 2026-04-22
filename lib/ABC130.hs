module ABC130 where

import Data.List (scanl')

solveA :: Int -> Int -> Int
solveA x a = if x < a then 0 else 10

solveB :: Int -> [Int] -> Int
solveB x ls = sum [if p <= x then 1 else 0 | p <- points]
  where
    points = scanl' (+) 0 ls
