module ABC089 where

import Data.List (group, sort)

solveA :: Int -> Int
solveA n = n `div` 3

solveB :: [String] -> String
solveB s = if length (group $ sort $ s) == 3 then "Three" else "Four"
