module ABC099 where

solveB :: Int -> Int -> Int
solveB a b = aFactorial - a
  where
    sub = b - a - 1
    aFactorial = sum [1 .. sub]
