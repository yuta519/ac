module ABC138 where

solveA :: Int -> String -> String
solveA a s = if a >= 3200 then s else "red"

solveB :: [Int] -> Float
solveB as = 1 / sum [1 / fromIntegral a | a <- as]
