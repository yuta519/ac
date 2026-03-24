module ABC097 where

solveA :: Int -> Int -> Int -> Int -> String
solveA a b c d
  | (abs a - c) <= d = "Yes"
  | (abs a - b) <= d && (abs b - c) <= d = "Yes"
  | otherwise = "No"

solveB :: Int -> Int
solveB x
  | x == 1 = 1
  | otherwise = maximum [i ^ j | i <- [2 .. x], j <- [2 .. x], i ^ j <= x]
