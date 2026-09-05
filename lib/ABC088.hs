module ABC088 where

import Data.List

solveA :: Int -> Int -> Bool
solveA n a = (n `mod` 500) <= a

solveB :: [Int] -> Int
solveB as = sub $ sortBy (flip compare) as

sortDesc :: [Int] -> [Int]
sortDesc = sortBy (flip compare)

sub :: [Int] -> Int
sub (a : b : xs) = (a - b) + sub xs
sub [a] = a
sub [] = 0
