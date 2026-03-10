module AGC030 where

solveA :: (Int, Int, Int) -> Int
solveA (a, b, c)
  | a + b >= c = b + c
  | otherwise = a + b + 1 + b
