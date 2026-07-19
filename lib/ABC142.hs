module ABC142 where

solveA :: Int -> Double
solveA n = fromIntegral ((n + 1) `div` 2) / fromIntegral n

solveB :: Int -> [Int] -> Int
solveB k hs = length [h | h <- hs, h >= k]
