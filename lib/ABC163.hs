module ABC163 where

import Data.Array (accumArray, elems)

solveA :: Float -> Float
solveA r = 2.0 * r * 3.14

solveC :: Int -> [Int] -> [Int]
solveC 0 [] = []
solveC n as =
  elems $ accumArray (+) 0 (1, n) [(a, 1) | a <- as]
