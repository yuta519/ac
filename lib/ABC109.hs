module ABC109 where

solveA :: Int -> Int -> String
solveA a b = if a `mod` 2 == 1 && b `mod` 2 == 1 then "Yes" else "No"
