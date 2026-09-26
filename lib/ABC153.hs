module ABC153 where

import qualified Data.List as List

solveA :: Int -> Int -> Int
solveA h a = if (h `mod` a) > 0 then (h `div` a) + 1 else h `div` a

solveB :: Int -> [Int] -> String
solveB h as = if h <= sum as then "Yes" else "No"

solveC :: Int -> [Int] -> Int
solveC k hs = sum $ take (length hs - k) $ List.sort hs

solveD :: Int -> Int
solveD h
  | h == 1 = 1
  | otherwise = solveD (h `div` 2) + solveD (h `div` 2) + 1
