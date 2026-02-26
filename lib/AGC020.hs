module AGC020 where

solveA :: Int -> Int -> String
solveA a b = if (b - a) `mod` 2 == 0 then "Alice" else "Borys"
