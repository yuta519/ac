module ABC140 where

solveA :: Int -> Int
solveA n = n * n * n

solveB :: [Int] -> [Int] -> [Int] -> Int
solveB a b c = sum [go prev cur | (prev, cur) <- zip (0 : a) a]
  where
    go prev cur
      | prev /= 0 && prev == (cur - 1) = b !! (cur - 1) + c !! (cur - 2)
      | otherwise = b !! (cur - 1)
