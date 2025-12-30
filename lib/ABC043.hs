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

solveD :: String -> (Int, Int)
solveD s = verifyBalance s 1

verifyBalance :: String -> Int -> (Int, Int)
verifyBalance s i = case s of
  (a : b : c : xs)
    | a == b -> (i, i + 1)
    | a == b || a == c || b == c -> (i, i + 2)
    | otherwise -> verifyBalance (b : c : xs) (i + 1)
  (a : b : [])
    | a == b -> (i, i + 1)
    | otherwise -> (-1, -1)
  _ -> (-1, -1)
