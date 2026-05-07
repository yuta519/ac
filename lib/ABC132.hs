module ABC132 where

import Data.List (foldl', sort)
import Data.Map (empty, insertWith, toList)

solveA :: String -> String
solveA s = if all (== 2) [freq | (_, freq) <- toList charFreq] then "Yes" else "No"
  where
    createCharMap m c = insertWith (+) c 1 m
    charFreq = foldl' createCharMap empty s

solveB :: [Int] -> Int
solveB ps = go ps 0
  where
    go (x : y : z : ps) count
      | (x < y && y < z) || (x > y && y > z) = go (y : z : ps) (count + 1)
      | otherwise = go (y : z : ps) count
    go (_ : _ : _) count = count

solveC :: Int -> [Int] -> Int
solveC n ds = length [a + 1 .. b]
  where
    ds' = sort ds
    a = ds' !! (n `div` 2 - 1)
    b = ds' !! (n `div` 2)
