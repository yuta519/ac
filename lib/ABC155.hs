module ABC155 where

solveA :: Int -> Int -> Int -> String
solveA a b c
  | a == b && b == c = "No"
  | a == b || b == c || a == c = "Yes"
  | otherwise = "No"

solveB :: [Int] -> String
solveB as = if null as'' then "APPROVED" else "DENIED"
  where
    as' = filter even as
    as'' = filter (\x -> x `mod` 3 > 0 && x `mod` 5 > 0) as'
