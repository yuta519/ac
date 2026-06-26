module ABC139 where

solveA :: String -> String -> Int
solveA s t = sum [1 | i <- [0 .. 2], s !! i == t !! i]

solveB :: Int -> Int -> Int
solveB a b = go 0
  where
    go cur
      | 1 + (a - 1) * cur < b = go (cur + 1)
      | otherwise = cur
