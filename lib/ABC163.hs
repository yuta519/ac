module ABC163 where

solveC :: Int -> [Int] -> [Int]
solveC 0 [] = []
solveC n as = do
  let xs = [0 | _ <- [1 .. n]] in incAt as xs

incAt :: [Int] -> [Int] -> [Int]
incAt (a : []) xs = take (a - 1) xs ++ [xs !! (a - 1) + 1] ++ drop a xs
incAt (a : as) xs = incAt as (take (a - 1) xs ++ [xs !! (a - 1) + 1] ++ drop a xs)
