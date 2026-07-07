module ABC140 where

solveA :: Int -> Int
solveA n = n * n * n

solveB :: [Int] -> [Int] -> [Int] -> Int
solveB a b c = base + bonus
  where
    base = sum [b !! (x - 1) | x <- a]
    bonus = sum [c !! (x - 1) | (x, y) <- zip a (tail a), y == x + 1]

solveC :: Int -> [Int] -> Int
solveC n b = h + l + r
  where
    h = head b
    l = last b
    r = sum [min (b !! i) (b !! (i - 1)) | i <- [1 .. (n - 2)]]
