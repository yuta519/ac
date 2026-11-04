module ABC158 where

import Debug.Trace

solveA :: String -> String
solveA [x] = "No"
solveA (x : y : zs) = if x /= y then "Yes" else solveA (y : zs)

solveB :: Int -> Int -> Int -> Int
solveB n a b = divisor + remainder
  where
    divisor = (n `div` (a + b)) * a
    remainder
      | n `mod` (a + b) == 0 = 0
      | n `mod` (a + b) >= a = a
      | otherwise = n `mod` (a + b)

solveC :: Int -> Int -> Int
solveC a b = traceShow a' traceShow b' (go a' b')
  where
    a' = (a * 100 + 8 - 1) `div` 8
    b' = b * 100 `div` 10
    go a' b'
      | a' == b' = a'
      | a' > b' && (a' `div` 10) == b = a'
      | a' < b' && (b' * 8 `div` 100) == a = b'
      | otherwise = -1
