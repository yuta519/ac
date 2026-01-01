module ABC061 where

solveB :: Int -> [(Int, Int)] -> [Int]
solveB n roads = foldl roundCountTransition (replicate n 0) roads

roundCountTransition :: [Int] -> (Int, Int) -> [Int]
roundCountTransition counts (x, y) =
  let counts' = incAt (x - 1) counts
      counts'' = incAt (y - 1) counts'
   in counts''

incAt :: Int -> [Int] -> [Int]
incAt i xs =
  take i xs ++ [xs !! i + 1] ++ drop (i + 1) xs
