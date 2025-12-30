module ABC044 where

solveA :: Int -> Int -> Int -> Int -> Int
solveA n k x y
  | n <= k = n * x
  | otherwise = k * x + (n - k) * y
