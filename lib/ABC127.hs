module ABC127 where

solveA :: Int -> Int -> Int
solveA a b
  | a >= 13 = b
  | a <= 5 = 0
  | otherwise = b `div` 2

solveB :: Int -> Int -> Int -> [Int]
solveB r d x2000 = take 10 $ tail $ iterate next x2000
  where
    next x = r * x - d
