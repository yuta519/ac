module ABC166 where

import Data.Array

solveA :: String -> String
solveA s = if s == "ABC" then "ARC" else "ABC"

solveC :: Int -> [Int] -> [(Int, Int)] -> Int
solveC 0 [] [] = 0
solveC n heights roads =
  let hArray = listArray (1, n) heights
      notGood =
        concatMap
          ( \(a, b) ->
              let ha = hArray ! a
                  hb = hArray ! b
               in [(a, False) | ha <= hb] ++ [(b, False) | hb <= ha]
          )
          roads
      good = accumArray (&&) True (1, n) notGood
   in length $ filter id $ elems good
