module ABC157 where

import Data.List (elemIndex)
import Debug.Trace (traceShow)

solveA :: Int -> Int
solveA n = (n + 2 - 1) `div` 2

-- solveB :: [[Int]] -> [Int] -> Bool
-- solveB as bs = traceShow as traceShow xs True
--   where
--     xs = [elemIndex b row | row <- as, b <- bs]
--     isRowBingo = any [all [xs !! 0, xs !! 1, xs !! 2]]
--     isColBingo = any [all [xs !! 0, xs !! 1, xs !! 2]]
--

solveC :: Int -> Int -> Int
solveC a b = traceShow a' traceShow b' (go a' b')
  where
    a' = (a * 100 + 8-1) `div` 8
    b' = b * 100 `div` 10
    go a' b'
      | a' == b' = a'
      | a' > b' && (a' `div` 10) == b = a'
      | a' < b' && (b' * 8 `div` 100) == a = b'
      | otherwise = -1
