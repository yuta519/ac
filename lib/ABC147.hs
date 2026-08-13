module ABC147 where

solveA :: Int -> Int -> Int -> String
solveA a b c = if sum [a, b, c] <= 21 then "win" else "bust"

solveB :: String -> Int
solveB s = sum [if x then 1 else 0 | x <- zipWith (/=) s (reverse s)] `div` 2
