module ABC061 where

solveA :: (Int, Int, Int) -> Bool
solveA (a, b, c) = a <= c && c <= b

solveB :: Int -> [(Int, Int)] -> [Int]
solveB n = foldl roundCountTransition (replicate n 0)

roundCountTransition :: [Int] -> (Int, Int) -> [Int]
roundCountTransition counts (x, y) =
  let counts' = incAt (x - 1) counts
      counts'' = incAt (y - 1) counts'
   in counts''

incAt :: Int -> [Int] -> [Int]
incAt i xs =
  take i xs ++ [xs !! i + 1] ++ drop (i + 1) xs
