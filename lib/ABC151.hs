module ABC151 where

import Data.Char (chr, ord)
import qualified Data.Foldable as Set
import qualified Data.Map as Map
import qualified Data.Set as Set

solveA :: Char -> Char
solveA c = chr $ ord c + 1

solveB :: Int -> Int -> Int -> Int -> Int
solveB n k m cur = if target > k then -1 else target
  where
    target = max (n * m - cur) 0

solveC :: [(Int, String)] -> (Int, Int)
solveC problems = go problems (Set.fromList ([] :: [Int])) (Map.fromList ([] :: [(Int, Int)]))
  where
    go :: [(Int, String)] -> Set.Set Int -> Map.Map Int Int -> (Int, Int)
    go [] resolved failed = (length resolved, sum $ Map.restrictKeys failed resolved)
    go ((p, s) : x) resolved failed
      | Set.member p resolved = go x resolved failed
      | s == "AC" = go x (Set.insert p resolved) failed
      | otherwise = go x resolved (Map.insertWith (+) p 1 failed)
