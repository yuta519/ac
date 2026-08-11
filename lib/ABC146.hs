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

solveC :: Integer -> Integer -> Integer -> Integer
solveC a b x = maximum (0 : [best n | n <- [1 .. 10], affordable n])
  where
    aMin n = 10 ^ (n - 1)
    aMax n = min stock (10 ^ n - 1)
    -- With n fixed the digit cost b * n is constant and a * N grows with N, so the
    -- best n-digit number is whatever the leftover budget buys, capped to the band.
    best n = min (aMax n) ((x - b * n) `div` a)
    affordable n = x - b * n >= 0 && best n >= aMin n
    stock = 10 ^ (9 :: Int)
