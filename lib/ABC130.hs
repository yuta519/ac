module ABC130 where

import Data.Array.Unboxed
import Data.List (scanl')

solveA :: Int -> Int -> Int
solveA x a = if x < a then 0 else 10

solveB :: Int -> [Int] -> Int
solveB x ls = length $ takeWhile (<= x) points
  where
    points = scanl' (+) 0 ls

solveC :: Int -> Int -> Int -> Int -> (Double, Int)
solveC w h x y
  | w == 2 * x && h == 2 * y = (fromIntegral (w * h) / 2, 1)
  | otherwise = (fromIntegral (w * h) / 2, 0)

solveD :: Int -> Int -> [Int] -> Int
solveD n k as = go 0 0 0 0
  where
    arr :: UArray Int Int
    arr = listArray (0, n - 1) as

    go left right sum res
      | left == n = res
      | sum < k && right < n = go left (right + 1) (sum + arr ! right) res
      | sum >= k = go (left + 1) right (sum - arr ! left) (res + (n - right + 1))
      | otherwise = res
