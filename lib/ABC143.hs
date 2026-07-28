module ABC143 where

import Data.Array (elems, listArray, (!))
import Data.List (sort, tails)

solveA :: Int -> Int -> Int
solveA a b
  | a - b * 2 > 0 = a - b * 2
  | otherwise = 0

solveB :: [Int] -> Int
solveB ds = sum [x * y | (x : ys) <- tails ds, y <- ys]

solveC :: Int -> String -> Int
solveC cur (x : y : zs) = if x == y then solveC (cur - 1) (y : zs) else solveC cur (y : zs)
solveC cur _ = cur

solveD :: Int -> [Int] -> Int
solveD n ls = sum [go i j | i <- [0 .. n - 2], j <- [i + 1 .. n - 1]]
  where
    arr = listArray (0, n - 1) (sort ls)
    go x y = length $ filter (\c -> c < (arr ! x) + (arr ! y)) $ map (arr !) [y + 1 .. n - 1]
