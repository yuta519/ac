module ABC128 where

import Data.List (sortBy)
import Data.Ord (Down (..), comparing)

solveA :: Int -> Int -> Int
solveA a p = (a * 3 + p) `div` 2

solveB :: [(String, Int)] -> [Int]
solveB xs = [i | (_, _, i) <- xs'']
  where
    xs' = [(a, b, i) | (i, (a, b)) <- zip [1 ..] xs]
    xs'' = sortBy (comparing (\(s, x, _) -> (s, Down x))) xs'
