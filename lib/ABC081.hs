module ABC081 where

solveA :: Int -> Int
solveA s = (s `div` 100) + (s `mod` 100 `div` 10) + (s `mod` 10)

solveB :: [Int] -> Int
solveB xs = minimum (map count2power xs)

count2power :: Int -> Int
count2power n
  | n == 0 = 0
  | n `mod` 2 /= 0 = 0
  | otherwise = 1 + count2power (n `div` 2)
