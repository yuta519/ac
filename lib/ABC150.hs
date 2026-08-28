module ABC150 where

solveA :: Int -> Int -> String
solveA k x = if k * 500 >= x then "Yes" else "No"

solveB :: String -> Int
solveB s = go s 0
  where
    go (a : b : c : xs) cnt
      | a == 'A' && b == 'B' && c == 'C' = go xs (cnt + 1)
      | otherwise = go (b : c : xs) cnt
    go _ cnt = cnt
