module ABC138 where

import Data.List (sort)

solveA :: Int -> String -> String
solveA a s = if a >= 3200 then s else "red"

solveB :: [Int] -> Float
solveB as = 1 / sum [1 / fromIntegral a | a <- as]

solveC :: [Int] -> Float
solveC vs = foldl (\acc y -> (acc + y) / 2) v vs'
  where
    (v : vs') = sort [fromIntegral v | v <- vs]
