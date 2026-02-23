module AGC010 where

solveA :: [Int] -> String
solveA as =
  let oddLength = length [a | a <- as, a `mod` 2 == 1]
   in if oddLength `mod` 2 == 0 then "YES" else "NO"
