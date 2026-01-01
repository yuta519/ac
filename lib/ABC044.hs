module ABC044 where

import Data.Bits (shiftL, xor)
import Data.Char (ord)
import Data.List

solveA :: Int -> Int -> Int -> Int -> Int
solveA n k x y
  | n <= k = n * x
  | otherwise = k * x + (n - k) * y

solveB :: String -> String
solveB w = if all even (map length . group $ sort w) then "Yes" else "No"

solveB' :: String -> String
solveB' w = if foldl xor 0 (map bitOf w) == 0 then "Yes" else "No"

bitOf :: Char -> Int
bitOf char = shiftL 1 (ord char - ord 'a') -- eaual to 1 << char

-- TODO: Skip this problem first. Will come back after learning DP
solveC :: Int
solveC = 0
