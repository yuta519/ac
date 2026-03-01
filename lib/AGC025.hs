module AGC025 where

import Data.List (foldl')

solveA :: String -> Int
solveA s = snd $ foldl' go (0, 0) s
  where
    go (cur, ans) c
      | c == 'B' = (cur + 1, ans)
      | c == 'W' = (cur, ans + cur)
