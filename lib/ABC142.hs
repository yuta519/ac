module ABC142 where

import Data.List (sortOn)

solveA :: Int -> Double
solveA n = fromIntegral ((n + 1) `div` 2) / fromIntegral n

solveB :: Int -> [Int] -> Int
solveB k hs = length [h | h <- hs, h >= k]

solveC :: Int -> [Int] -> [Int]
solveC n as = map fst $ sortOn snd $ zip [1 .. n] as
