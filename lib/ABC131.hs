module ABC131 where

import Data.List (scanl', sortBy)
import Data.Ord (comparing)

solveA :: String -> String
solveA (x : y : s)
  | x == y = "Bad"
  | otherwise = solveA (y : s)
solveA _ = "Good"

solveB :: Int -> Int -> Int
solveB n l
  | l == 0 || l < 0 && (n + l) > 0 = sum $ map (+ l) [0 .. n - 1]
  | l > 0 = sum $ tail $ map (+ l) [0 .. n - 1]
  | l < 0 = sum $ init $ map (+ l) [0 .. n - 1]

solveC :: Integer -> Integer -> Integer -> Integer -> Integer
solveC a b c d = b - a + 1 - count a b c - count a b d + count a b (lcm c d)
  where
    count lo hi x = hi `div` x - (lo - 1) `div` x

solveD :: [(Int, Int)] -> String
solveD tasks = if all id checks then "Yes" else "No"
  where
    tasks' = sortBy (comparing snd) tasks
    durations = tail $ scanl' (+) 0 [a | (a, _) <- tasks']
    deadlines = [b | (_, b) <- tasks']
    checks = zipWith (<=) durations deadlines
