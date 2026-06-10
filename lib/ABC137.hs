module ABC137 where

solveA :: Int -> Int -> Int
solveA a b = maximum [a + b, a - b, a * b]

solveB :: Int -> Int -> [Int]
solveB k x = [x - k + 1 .. x + k - 1]
