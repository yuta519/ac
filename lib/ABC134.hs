module ABC134 where

solveA :: Int -> Int
solveA r = 3 * r * r

solveB :: Int -> Int -> Int
solveB n d = go 0
  where
    go cur = if cur * (2 * d + 1) >= n then cur else go (cur + 1)
