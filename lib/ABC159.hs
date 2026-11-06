module ABC159 where

solveA :: Int -> Int -> Int
solveA n m = n * (n - 1) `div` 2 + m * (m - 1) `div` 2
