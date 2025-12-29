module ABC043 where

solveA :: Int -> Int
-- solveA n = sum [i | i <- [1 .. n]]
solveA n = div (n * (n + 1)) 2

solveB :: String -> String
solveB s = unhappyHacking s ""

unhappyHacking :: String -> String -> String
unhappyHacking [] cur = cur
unhappyHacking (x : xs) cur = case x of
  '0' -> unhappyHacking xs (cur ++ [x])
  '1' -> unhappyHacking xs (cur ++ [x])
  'B' -> unhappyHacking xs (if (length cur) > 0 then init cur else cur)
  _ -> cur

solveB' :: String -> String
solveB' s = reverse $ foldl process [] s
  where
    process :: String -> Char -> String
    process stack c = case c of
      '0' -> c : stack
      '1' -> c : stack
      'B' -> case stack of
        [] -> []
        (_ : xs) -> xs
      _ -> stack

solveC :: [Int] -> Int
solveC a = if fCost < cCost then fCost else cCost
  where
    f = floor (fromIntegral (sum a) / fromIntegral (length a))
    c = ceiling (fromIntegral (sum a) / fromIntegral (length a))
    fCost = sum [(x - f) ^ 2 | x <- a]
    cCost = sum [(x - c) ^ 2 | x <- a]
