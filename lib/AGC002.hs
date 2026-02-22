module AGC002 where

solveA :: Int -> Int -> String
solveA a b
  | a > 0 && b > 0 = "Positive"
  | a <= 0 && b >= 0 = "Zero"
  | a < 0 && b < 0 = if (a - b) `mod` 2 == 0 then "Negative" else "Positive"
