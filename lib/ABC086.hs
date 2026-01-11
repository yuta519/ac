module ABC086 where

solveA :: Int -> Int -> String
solveA a b = if (a * b) `mod` 2 == 0 then "Even" else "Odd"
