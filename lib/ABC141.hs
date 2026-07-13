module ABC141 where

import Data.Array (accumArray, (!))

solveA :: String -> String
solveA s
  | s == "Sunny" = "Cloudy"
  | s == "Cloudy" = "Rainy"
  | s == "Rainy" = "Sunny"

solveB :: String -> Bool
solveB s = and [check p c | (p, c) <- combinations]
  where
    combinations = zip [1 .. length s] s
    check p c
      | even p = c == 'L' || c == 'U' || c == 'D'
      | p `mod` 2 == 1 = c == 'R' || c == 'U' || c == 'D'

solveC :: Int -> Int -> Int -> [Int] -> [String]
solveC n k q a = [if (a' ! i) > (q - k) then "Yes" else "No" | i <- [1 .. n]]
  where
    a' = accumArray (+) 0 (1, n) [(i, 1) | i <- a]
