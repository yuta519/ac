module ABC133 where

solveA :: Int -> Int -> Int -> Int
solveA n a b = if n * a < b then n * a else b

solveB :: [[Int]] -> Int
solveB a = go a 0
  where
    go [] cur = cur
    go (x : xs) cur = go xs (cur + sum [if isSquareInt $ sum $ map (^ 2) (zipWith (-) x y) then 1 else 0 | y <- xs])

    isSquareInt :: Int -> Bool
    isSquareInt n = r * r == n
      where
        r = floor . sqrt $ fromIntegral n
