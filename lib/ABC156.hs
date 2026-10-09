module ABC156 where

solveA :: Int -> Int -> Int
solveA n r = if n >= 10 then r else r + 100 * (10 - n)

solveB :: Int -> Int -> Int
solveB n k = go 1
  where
    go cur = if n >= k ^ cur then go (cur + 1) else cur
