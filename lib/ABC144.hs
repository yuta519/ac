module ABC144 where

solveA :: Int -> Int -> Int
solveA a b
  | 1 <= a && a <= 9 && 1 <= b && b <= 9 = a * b
  | otherwise = -1

solveB :: Int -> String
solveB n = if sum [1 | i <- [1 .. 9], n `div` i < 10 && n `mod` i == 0] > 0 then "Yes" else "No"
