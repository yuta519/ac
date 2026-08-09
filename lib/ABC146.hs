module ABC146 where

import Data.Char (chr, ord)

solveA :: String -> Int
solveA s
  | s == "SUN" = 7
  | s == "MON" = 6
  | s == "TUE" = 5
  | s == "WED" = 4
  | s == "THU" = 3
  | s == "FRI" = 2
  | s == "SAT" = 1

solveB :: Int -> String -> String
solveB n = map rotate
  where
    rotate c = chr (ord 'A' + (ord c - ord 'A' + n) `mod` 26)
