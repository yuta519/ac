module ABC131 where

solveA :: String -> String
solveA (x : y : s)
  | x == y = "Bad"
  | otherwise = solveA (y : s)
solveA _ = "Good"
