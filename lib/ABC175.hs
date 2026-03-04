module ABC175 where

import Data.List (foldl', group, sort)

solveA :: String -> Int
solveA s = snd $ foldl' go (0, 0) s
  where
    go (cur, ans) c
      | c == 'R' = (cur + 1, max (cur + 1) ans)
      | c == 'S' = (0, ans)

solveB :: [Int] -> Int
solveB ls =
  sum
    [ freq !! i * freq !! j * freq !! k
      | i <- [0 .. m - 3],
        j <- [i + 1 .. m - 2],
        k <- [j + 1 .. m - 1],
        lengths !! i + lengths !! j > lengths !! k
    ]
  where
    freq = fmap length $ group $ sort ls
    lengths = fmap head $ group $ sort ls
    m = length lengths

solveC :: Integer -> Integer -> Integer -> Integer
solveC x k d
  | k <= (x' `div` d) = x' - k * d
  | even $ k - d' = m'
  | otherwise = abs (m' - d)
  where
    x' = abs x
    d' = x' `div` d
    m' = x' `mod` d
