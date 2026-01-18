module ABC085 where

import Data.List

solveB :: [Int] -> Int
solveB xs = kagamiMochi $ nub $ sort xs

kagamiMochi :: [Int] -> Int
kagamiMochi [] = 0
kagamiMochi [a] = 1
kagamiMochi (a : b : xs) = (if a < b then 1 else 0) + kagamiMochi (b : xs)

solveC :: Int -> Int -> (Int, Int, Int)
solveC n y = case [(a, b, c) | a <- [0 .. n], b <- [0 .. (n - a)], let c = n - a - b, y == ((a * 10000) + (b * 5000) + (c * 1000))] of
  (x : _) -> x
  [] -> (-1, -1, -1)
