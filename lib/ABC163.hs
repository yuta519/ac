module ABC163 where

import Data.Array (accumArray, elems)

solveA :: Float -> Float
solveA r = 2.0 * r * 3.14

solveB :: Int -> [Int] -> Int
solveB n as = if n >= total_homework then n - total_homework else -1
  where
    total_homework = sum as

solveC :: Int -> [Int] -> [Int]
solveC 0 [] = []
solveC n as =
  elems $ accumArray (+) 0 (1, n) [(a, 1) | a <- as]
