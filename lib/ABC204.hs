{-# LANGUAGE TypeApplications #-}

module ABC204 where

import Data.Array

solveA :: Int -> Int -> Int
solveA x y
  | x == y = x
  | otherwise = 3 - x - y
