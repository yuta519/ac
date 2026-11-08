module ABC159 where

import Debug.Trace

solveA :: Int -> Int -> Int
solveA n m = n * (n - 1) `div` 2 + m * (m - 1) `div` 2

solveB :: String -> String
solveB s = if first == second && go first && go second then "Yes" else "No"
  where
    firstLength = length s `div` 2
    first = take firstLength s
    second = drop (firstLength + 1) s

    go :: String -> Bool
    go [] = True
    go [_] = True
    go (c : rest) = c == last rest && go (init rest)
