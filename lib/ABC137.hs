module ABC137 where

import Data.List (group, sort, sortBy, sortOn)
import Data.Set as Set (deleteMin, empty, insert, size, toList)

solveA :: Int -> Int -> Int
solveA a b = maximum [a + b, a - b, a * b]

solveB :: Int -> Int -> [Int]
solveB k x = [x - k + 1 .. x + k - 1]

solveC :: [String] -> Int
solveC ss = sum [k * (k - 1) `div` 2 | s <- ss', let k = length s]
  where
    ss' = group $ sort [sort s | s <- ss]

solveD :: Int -> [(Int, Int)] -> Int
solveD n works = go empty jobs' 0
  where
    jobs = [(n - a + 1, b) | (a, b) <- works, n - a >= 0]
    jobs' = sortBy (\(x, _) (y, _) -> compare x y) jobs

    go heap [] _ = sum [b | (b, _) <- toList heap]
    go heap ((d, b) : rest) idx =
      let heap' = insert (b, idx) heap
       in if size heap' > d
            then go (deleteMin heap') rest (idx + 1)
            else go heap' rest (idx + 1)
