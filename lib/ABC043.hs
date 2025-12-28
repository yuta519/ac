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
