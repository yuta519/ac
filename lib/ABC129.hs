module ABC129 where

import Data.List (scanl', sort)

solveA :: [Int] -> Int
solveA hours = x + y
  where
    (x : y : _) = sort hours

solveB :: [Int] -> Int
solveB ws = minimum [abs ((s) - (a - s)) | s <- ws']
  where
    ws' = scanl' (+) 0 ws
    a = sum ws
