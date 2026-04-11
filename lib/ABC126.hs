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

solveC :: Int -> Int -> Int -> [Int]
solveC r d x2000 = take 10 $ tail $ iterate next x2000
  where
    next x = r * x - d
