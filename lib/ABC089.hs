module ABC089 where

import Data.Int (Int64)
import Data.List (foldl', group, sort)

solveA :: Int -> Int
solveA n = n `div` 3

solveB :: [String] -> String
solveB s = if length (group $ sort $ s) == 3 then "Three" else "Four"

solveC :: [String] -> Int64
solveC names =
  let (m, a, r, c, h) = foldl' cnt (0, 0, 0, 0, 0) names

      cnt :: (Int, Int, Int, Int, Int) -> String -> (Int, Int, Int, Int, Int)
      cnt (m, a, r, c, h) s =
        case head s of
          'M' -> (m + 1, a, r, c, h)
          'A' -> (m, a + 1, r, c, h)
          'R' -> (m, a, r + 1, c, h)
          'C' -> (m, a, r, c + 1, h)
          'H' -> (m, a, r, c, h + 1)
          _ -> (m, a, r, c, h)

      counts :: [Int64]
      counts = map fromIntegral [m, a, r, c, h]

      answer =
        sum
          [ x * y * z
            | (i, x) <- zip [0 ..] counts,
              (j, y) <- zip [0 ..] counts,
              j > i,
              (k, z) <- zip [0 ..] counts,
              k > j
          ]
   in answer
