module ABC129 where

import Data.List (sort)

solveA :: [Int] -> Int
solveA hours = x + y
  where
    (x : y : _) = sort hours
