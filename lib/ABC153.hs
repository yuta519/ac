module ABC153 where

solveA :: Int -> Int -> Int
solveA h a = if (h `mod` a) > 0 then (h `div` a) + 1 else h `div` a

solveB :: Int -> [Int] -> String
solveB h as = if h <= sum as then "Yes" else "No"
