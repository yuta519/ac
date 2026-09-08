module ABC151 where

import Data.Char (chr, ord)

solveA :: Char -> Char
solveA c = chr $ ord c + 1

solveB :: Int -> Int -> Int -> Int -> Int
solveB n k m cur = if target > k then -1 else target
  where
    target = max (n * m - cur) 0
