module ABC143 where

solveA :: Int -> Int -> Int
solveA a b
  | a - b * 2 > 0 = a - b * 2
  | otherwise = 0

solveB :: [Int] -> Int
solveB ds = sum [(ds !! i) * (ds !! j) | i <- [0 .. (length ds - 2)], j <- [i + 1 .. (length ds - 1)]]
