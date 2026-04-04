module ABC047 where

solveA :: Int -> Int -> Int -> String
solveA a b c =
  let most = maximum [a, b, c]
      amount = sum [a, b, c]
   in if amount `div` most == 2 && amount `mod` most == 0 then "Yes" else "No"
