module ABC175 where

import Data.List (foldl')

solveA :: String -> Int
solveA s = snd $ foldl' go (0, 0) s
  where
    go (cur, ans) c
      | c == 'R' = (cur + 1, max (cur + 1) ans)
      | c == 'S' = (0, ans)

solveC :: Integer -> Integer -> Integer -> Integer
solveC x k d
  | k <= (x' `div` d) = x' - k * d
  | even $ k - d' = m'
  | otherwise = abs (m' - d)
  where
    x' = abs x
    d' = x' `div` d
    m' = x' `mod` d
