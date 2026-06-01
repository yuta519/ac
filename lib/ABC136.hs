module ABC136 where

solveA :: Int -> Int -> Int -> Int
solveA a b c =
  let remain = a - b
   in if c <= remain then 0 else c - remain
