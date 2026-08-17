module ABC147 where

import Control.Monad (replicateM)

solveA :: Int -> Int -> Int -> String
solveA a b c = if sum [a, b, c] <= 21 then "win" else "bust"

solveB :: String -> Int
solveB s = length (filter id (zipWith (/=) s (reverse s))) `div` 2

solveC :: [[(Int, Int)]] -> Int
solveC xs = maximum [length $ filter id c | c <- combinations, consistent c]
  where
    combinations = replicateM (length xs) [True, False]
    consistent c = and [c !! (x - 1) == (y == 1) | (isHonest, sts) <- zip c xs, isHonest, (x, y) <- sts]
