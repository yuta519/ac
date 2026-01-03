module ABC163 where

import Data.Array (accumArray, elems)

solveC :: Int -> [Int] -> [Int]
solveC 0 [] = []
solveC n as =
  elems $ accumArray (+) 0 (1, n) [(a, 1) | a <- as]
