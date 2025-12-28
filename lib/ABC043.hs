module ABC043 where

solveA :: Int -> Int
-- solveA n = sum [i | i <- [1 .. n]]
solveA n = div (n * (n + 1)) 2
