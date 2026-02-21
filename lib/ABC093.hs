module ABC093 where

import Data.List (sort)

solveC :: (Int, Int, Int) -> Int -> Int
solveC (a, b, c) cur
  | a == b && b == c = cur
  | otherwise = if (snd - min) >= 2 then solveC (min + 2, snd, trd) cur + 1 else solveC (min + 1, snd + 1, trd) cur + 1
  where
    aaa = minimum [a, b, c]
    s = sort [a, b, c]
    min = s !! 0
    snd = s !! 1
    trd = s !! 2
