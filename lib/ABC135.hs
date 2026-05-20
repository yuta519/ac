module ABC135 where

solveA :: Int -> Int -> Maybe Int
solveA a b
  | abs (a - b) `mod` 2 > 0 = Nothing
  | otherwise = Just $ abs (a - b) `div` 2 + min a b

solveB :: Int -> [Int] -> Bool
solveB n ps = diff == 0 || diff == 2
  where
    comb = zip [1 .. n] ps
    diff = sum [1 | (n, p) <- comb, n /= p]
