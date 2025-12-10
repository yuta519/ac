module ABC042 (solveA, solveB) where

import Data.List (sort)
import Data.Maybe (catMaybes)
import Text.Read (readMaybe)

solveA :: String -> String
solveA syllables = if count 5 syls == 2 && count 7 syls == 1 then "YES" else "NO"
 where
 syls = stringsToInts [s | s <- words syllables]

count :: Int -> [Int] -> Int
count x xs = length $ filter (== x) xs

stringsToInts :: [String] -> [Int]
stringsToInts xs = catMaybes $ map readMaybe xs

solveB :: [String] -> String
solveB xs = concat $ sort xs
