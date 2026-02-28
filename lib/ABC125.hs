module ABC125 where

solveD :: [Int] -> Int
solveD as =
  if even $ length $ filter (< 0) as
    then total
    else total - (min * 2)
  where
    total = sum $ map abs as
    min = minimum $ map abs as
