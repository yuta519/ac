module ABC145 where

solveA :: Int -> Int
solveA n = n * n

solveB :: Int -> String -> String
solveB n s
  | n `mod` 2 > 0 = "No"
  | take (n `div` 2) s == drop (n `div` 2) s = "Yes"
  | otherwise = "No"
