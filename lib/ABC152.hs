module ABC152 where

solveA :: Int -> Int -> String
solveA n m = if n == m then "Yes" else "No"

solveB :: Int -> Int -> Int
solveB a b = go (min a b) (max a b) 0
  where
    go x y cur
      | y == 0 = cur
      | otherwise = go x (y - 1) cur * 10 + x

solveC :: [Int] -> Int
solveC ps = go (length ps) ps 0
  where
    go cur [] result = result
    go cur (x : xs) result = if cur < x then go cur xs result else go x xs (result + 1)
