module ABC148 where

solveA :: Int -> Int -> Int
solveA a b = 6 - a - b

solveB :: String -> String -> String
solveB s t = concat $ zipWith (\a b -> [a, b]) s t

solveC :: Int -> Int -> Int
solveC a b
  | a == b = a
  | a < b && b `mod` a == 0 = b
  | a > b && a `mod` b == 0 = a
  | otherwise = lcm a b
