module ABC126 where

import Data.Char (toLower)

solveA :: Int -> String -> String
solveA k s
  | k <= 0 = s
  | k > length s = s
  | otherwise =
      let (before, c : after) = splitAt (k - 1) s
       in before ++ toLower c : after
