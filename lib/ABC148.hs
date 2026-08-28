module ABC148 where

solveA :: Int -> Int -> Int
solveA a b = 6 - a - b

solveB :: String -> String -> String
solveB s t = concat $ zipWith (\a b -> [a, b]) s t

solveC :: Int -> Int -> Int
solveC a b
  | a == b = a
  | a < b && b `mod` a == 0 = b
  | a > b && a `mod` b == 0 = a
  | otherwise = lcm a b

solveD :: [Int] -> Int
solveD as = if ans > 0 then length as - ans else -1
  where
    go t [] = t - 1
    go t (x : xs) = if t == x then go (t + 1) xs else go t xs
    ans = go 1 as
