module AGC024 where

solveA :: Int -> Int -> Int -> Int -> Int
solveA a b c k = if k `mod` 2 > 0 then b - a else a - b
