module ABC144 where

solveA :: Int -> Int -> Int
solveA a b
  | 1 <= a && a <= 9 && 1 <= b && b <= 9 = a * b
  | otherwise = -1
