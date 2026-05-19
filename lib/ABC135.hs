module ABC135 where

solveA :: Int -> Int -> Int
solveA a b
  | abs (a - b) `mod` 2 > 0 = -1
  | otherwise = abs (a - b) `div` 2 + min a b
