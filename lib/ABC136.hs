module ABC136 where

solveA :: Int -> Int -> Int -> Int
solveA a b c =
  let remain = a - b
   in if c <= remain then 0 else c - remain

solveB :: Int -> Int
solveB n = length [i | i <- [1 .. n], odd $ length (show i)]

solveC :: [Int] -> Bool
solveC = go 0
  where
    go _ [] = True
    go prev (h : hs)
      | h - 1 >= prev = go (h - 1) hs
      | h >= prev = go h hs
      | otherwise = False
