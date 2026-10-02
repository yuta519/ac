module ABC154 where

import qualified Data.Set as Set

solveA :: (String, Int) -> (String, Int) -> String -> (Int, Int)
solveA (s, sCount) (t, tCount) u = if s == u then (sCount - 1, tCount) else (sCount, tCount - 1)

solveB :: String -> String
solveB s = ['x' | _ <- [1 .. (length s)]]

solveC :: Int -> [Int] -> String
solveC n s = if n == length (Set.toList $ Set.fromList s) then "YES" else "NO"
