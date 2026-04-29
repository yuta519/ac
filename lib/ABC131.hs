module ABC131 where

solveA :: String -> String
solveA (x : y : s)
  | x == y = "Bad"
  | otherwise = solveA (y : s)
solveA _ = "Good"

solveB :: Int -> Int -> Int
solveB n l
  | l == 0 || l < 0 && (n + l) > 0 = sum $ map (+ l) [0 .. n - 1]
  | l > 0 = sum $ tail $ map (+ l) [0 .. n - 1]
  | l < 0 = sum $ init $ map (+ l) [0 .. n - 1]
