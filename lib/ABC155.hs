module ABC155 where

solveA :: Int -> Int -> Int -> String
solveA a b c
  | a == b && b == c = "No"
  | a == b || b == c || a == c = "Yes"
  | otherwise = "No"
