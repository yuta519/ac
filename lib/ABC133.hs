module ABC133 where

solveA :: Int -> Int -> Int -> Int
solveA n a b = if n * a < b then n * a else b
