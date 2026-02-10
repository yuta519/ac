module ABC053 where

solveA :: Int -> String
solveA x = if x < 1200 then "ABC" else "ARC"

-- solveC :: Int -> Int
-- solveC x = (x `div` 11) * 2 + if (x `mod` 11) >= 7 then 2 else 1
solveC :: Integer -> Integer
solveC x =
  let q = x `div` 11
      r = x `mod` 11
   in q * 2 + case r of
        0 -> 0
        _
          | r <= 6 -> 1
          | otherwise -> 2
