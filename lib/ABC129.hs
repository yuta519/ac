module ABC129 where

import Data.Array
import Data.List (scanl', sort)
import Data.Set (fromList, member)

solveA :: [Int] -> Int
solveA hours = x + y
  where
    (x : y : _) = sort hours

solveB :: [Int] -> Int
solveB ws = minimum [abs ((s) - (a - s)) | s <- ws']
  where
    ws' = scanl' (+) 0 ws
    a = sum ws

solveC :: Int -> [Int] -> Int
solveC n broken = dp ! n
  where
    brokenSet = fromList broken

    dp :: Array Int Int
    dp = listArray (0, n) [f i | i <- [0 .. n]]

    f :: Int -> Int
    f 0 = 1
    f 1 = if member 1 brokenSet then 0 else 1
    f i
      | member i brokenSet = 0
      | otherwise = ((dp ! (i - 1)) + (dp ! (i - 2))) `mod` 1000000007
