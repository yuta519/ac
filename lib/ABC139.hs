module ABC139 where

solveA :: String -> String -> Int
solveA s t = sum [1 | i <- [0 .. 2], s !! i == t !! i]
