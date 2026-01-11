module ABC081 where

solveA :: Int -> Int
solveA s = (s `div` 100) + (s `mod` 100 `div` 10) + (s `mod` 10)
