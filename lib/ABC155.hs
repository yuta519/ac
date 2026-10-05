module ABC155 where

import Data.List (group, sort)

solveA :: Int -> Int -> Int -> String
solveA a b c
  | a == b && b == c = "No"
  | a == b || b == c || a == c = "Yes"
  | otherwise = "No"

solveB :: [Int] -> String
solveB as = if not violation then "APPROVED" else "DENIED"
  where
    violation = any (\x -> even x && x `mod` 3 /= 0 && x `mod` 5 /= 0) as

solveC :: [String] -> [String]
solveC ss = [head x | x <- sorted, max == length x]
  where
    sorted = group $ sort ss
    max = maximum [length x | x <- sorted]
