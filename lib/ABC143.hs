module ABC143 where

solveA :: Int -> Int -> Int
solveA a b
  | a - b * 2 > 0 = a - b * 2
  | otherwise = 0
