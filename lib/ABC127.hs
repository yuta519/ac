module ABC127 where

solveA :: Int -> Int -> Int
solveA a b
  | a >= 13 = b
  | a <= 5 = 0
  | otherwise = b `div` 2
