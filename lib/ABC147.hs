module ABC147 where

solveA :: Int -> Int -> Int -> String
solveA a b c = if sum [a, b, c] <= 21 then "win" else "bust"

solveB :: String -> Int
solveB s = length (filter id (zipWith (/=) s (reverse s))) `div` 2
