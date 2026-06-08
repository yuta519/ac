module ABC137 where

solveA :: Int -> Int -> Int
solveA a b = maximum [(a + b), (a - b), (a * b)]
