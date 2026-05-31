module ABC134 where

import Data.List (sort)

solveA :: Int -> Int
solveA r = 3 * r * r

solveB :: Int -> Int -> Int
solveB n d = go 0
  where
    go cur = if cur * (2 * d + 1) >= n then cur else go (cur + 1)

solveC :: [Int] -> [Int]
solveC as = map (\a -> if a /= first then first else second) as
  where
    as' = reverse $ sort as
    first = as' !! 0
    second = as' !! 1
