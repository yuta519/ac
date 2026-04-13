module ABC126 where

import Data.Char (toLower)

solveA :: Int -> String -> String
solveA k s
  | k <= 0 = s
  | k > length s = s
  | otherwise =
      let (before, c : after) = splitAt (k - 1) s
       in before ++ toLower c : after

solveB :: String -> String
solveB s =
  let (x, y) = splitAt 2 s
      a = read x :: Int
      b = read y :: Int
      isMM = 1 <= a && a <= 12
      isYY = 1 <= b && b <= 12
   in case (isMM, isYY) of
        (True, True) -> "AMBIGUOUS"
        (True, False) -> "MMYY"
        (False, True) -> "YYMM"
        (False, False) -> "NA"

-- n < k
-- n=3 k=10
-- lst = [1, 2, 3]
-- lst = [16, 16, 12]
-- lst = [1*16, 2*8, 3*4]
-- lst = [4, 3, 2]
solveC :: Int -> Int -> Double
solveC n k =
  let lst = [1 / fromIntegral ((make i 1) * n) | i <- [1 .. n]]
   in sum lst
  where
    make :: Int -> Int -> Int
    make base cur
      | base * cur >= k = cur
      | otherwise = make base (cur * 2)
