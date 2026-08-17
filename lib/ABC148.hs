module ABC148 where

solveA :: Int -> Int -> Int
solveA a b = 6 - a - b

solveB :: String -> String -> String
solveB s t = concat $ zipWith (\a b -> [a, b]) s t
