module ABC156 where

solveA :: Int -> Int -> Int
solveA n r = if n >= 10 then r else r + 100 * (10 - n)
