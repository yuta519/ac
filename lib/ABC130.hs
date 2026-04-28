module ABC130 where

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
    -- 6, 1, 2, 7
    -- (0, 0) 0+6-6+6 = 6
    -- (0, 1) 6+6-6+1 = 7
    -- (0, 2) 7+6-6+2 = 9
    -- (0, 3) 9+6-6+7 = 16 !!
    -- (0, 3) 9+6-6+7 = 16 !!
    -- go left right currentSum res
    --   | left == n = res
    --   | currentSum < k && right < n = go left (right + 1) (currentSum + as !! right) res
    --   | currentSum >= k = go (left + 1) right (currentSum - (as !! left)) (res + n - right)
    --   | otherwise = res
    go left right sum res
      | left == n = res
      | sum < k && right < n = go left (right + 1) (sum + as !! right) res
      | sum >= k = go (left + 1) right (sum - as !! left) (res + (n - right + 1))
      | otherwise = res
