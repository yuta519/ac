module ABC130 where

import Data.List (scanl')

solveA :: Int -> Int -> Int
solveA x a = if x < a then 0 else 10

solveB :: Int -> [Int] -> Int
solveB x ls = length $ takeWhile (<= x) points
  where
    points = scanl' (+) 0 ls
