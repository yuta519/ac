module ABC149 where

solveA :: String -> String -> String
solveA s t = t ++ s

solveB :: Int -> Int -> Int -> (Int, Int)
solveB a b k
  | k == 0 = (a, b)
  | a > 0 = if k <= a then (a - k, b) else solveB 0 b (k - a)
  | b > 0 = if k < b then (a, b - k) else solveB a 0 (k - b)
  | otherwise = solveB a b 0
