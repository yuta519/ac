module ABC097 where

solveB :: Int -> Int
solveB x
  | x == 1 = 1
  | otherwise = maximum [i ^ j | i <- [2 .. x], j <- [2 .. x], i ^ j <= x]
