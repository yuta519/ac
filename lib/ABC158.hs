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
