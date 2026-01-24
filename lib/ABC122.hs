module ABC122 where

import Data.Array

-- Convert input String to Char Array
-- Create the Array to store the positions which is possible to make "AC" (The position should 'C')
-- Create the cumulative sum (cs) from the AC array
solveC :: Int -> String -> [(Int, Int)] -> [Int]
solveC n s lts =
  let sArray = listArray (1, n) s
      ac = listArray (1, n) $ 0 : [if sArray ! (i - 1) == 'A' && sArray ! i == 'C' then 1 else 0 | i <- [2 .. n]]
      cs = listArray (0, n) $ scanl (+) 0 (elems ac)
   in [cs ! r - cs ! l | (l, r) <- lts]
