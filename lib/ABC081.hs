module ABC081 where

import Data.Array.Unboxed
import Data.List (sort)
import qualified Data.Map.Strict as M

solveA :: Int -> Int
solveA s = (s `div` 100) + (s `mod` 100 `div` 10) + (s `mod` 10)

solveB :: [Int] -> Int
solveB xs = minimum (map count2power xs)

count2power :: Int -> Int
count2power n
  | n == 0 = 0
  | n `mod` 2 /= 0 = 0
  | otherwise = 1 + count2power (n `div` 2)

-- 1. Create counter o(n)
-- 2. Sort counter list at asc o(log n)
-- 3. Check if the length of Counter is lower than K or not
-- 4. If the length is greater than K, calculate the subtract of the length and K
-- 5. Take the numbers of the subtract from Counter
-- 6. Return the sum of taken numbers
--
-- example: k=2, as=[1, 1, 2, 2, 5]
-- { 1: 2, 2: 2, 5: 1 }
-- solveC :: Int -> [Int] -> Int
-- solveC k as = 0
--   where
--     counter :: UArray Int Int
--     counter = accumArray (+) 0 (1, length as) [(a, 1) | a <- as]

solveC' :: Int -> [Int] -> Int
solveC' k as
  | m <= k = 0
  | otherwise = sum $ take (m - k) freqs
  where
    freqs = sort . M.elems $ M.fromListWith (+) [(a, 1) | a <- as]
    m = length freqs
