module ABC044 where

import Data.List

solveA :: Int -> Int -> Int -> Int -> Int
solveA n k x y
  | n <= k = n * x
  | otherwise = k * x + (n - k) * y

solveB :: String -> String
solveB w = if all even (map length . group $ sort w) then "Yes" else "No"
