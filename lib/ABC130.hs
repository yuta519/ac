module ABC130 where

import Data.List (scanl')

solveA :: Int -> Int -> Int
solveA x a = if x < a then 0 else 10

solveB :: Int -> [Int] -> Int
solveB x ls = length $ takeWhile (<= x) points
  where
    points = scanl' (+) 0 ls

solveC :: Int -> Int -> Int -> Int -> (Double, Int)
solveC w h x y
  | w == 2 * x && h == 2 * y = (fromIntegral (w * h) / 2, 1)
  | otherwise = (fromIntegral (w * h) / 2, 0)
