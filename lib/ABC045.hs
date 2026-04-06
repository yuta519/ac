module ABC045 where

solveA :: (Int, Int, Int) -> Int
solveA (a, b, h) = (a + b) * h `div` 2

solveB :: (String, String, String) -> Char -> Char
solveB (a, b, c) turn
  | turn == 'a' =
      case a of
        [] -> 'A'
        (x : xs) -> solveB (xs, b, c) x
  | turn == 'b' =
      case b of
        [] -> 'B'
        (x : xs) -> solveB (a, xs, c) x
  | turn == 'c' =
      case c of
        [] -> 'C'
        (x : xs) -> solveB (a, b, xs) x

-- 999999999
-- 99
-- 9 + 9, 99
--
-- 999
-- 9 + 9 + 9, 9 + 99, 99 + 9, 999
--
-- 9999
-- 9 + 9 + 9 + 9, 9 + 999, 9 + 99 + 9, 999 + 9, 9999
