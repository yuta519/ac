module ABC140 where

solveA :: Int -> Int
solveA n = n * n * n

solveB :: [Int] -> [Int] -> [Int] -> Int
solveB a b c = base + bonus
  where
    base = sum [b !! (x - 1) | x <- a]
    bonus = sum [c !! (x - 1) | (x, y) <- zip a (tail a), y == x + 1]
