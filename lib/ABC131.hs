module ABC131 where

solveA :: String -> String
solveA [] = "Good"
solveA (x : y : s) = if x == y then "Bad" else solveA (y : s)
solveA (x : _) = "Good"
