{-# LANGUAGE TypeApplications #-}

module ABC204 where

import Data.Array

solveA :: Int -> Int -> Int
solveA x y
  | x == y = x
  | otherwise = 3 - x - y

solveB :: [Int] -> Int
solveB as = sum [a - 10 | a <- as, a > 10]
