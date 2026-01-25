module ABC068 where

import Data.Array
import Data.Graph
import qualified Data.IntSet as S

solveA :: Int -> String
solveA n = "ABC" ++ show n

solveB :: Int -> Int
solveB 1 = 1
solveB n = go n 2
  where
    go n cur
      | n > cur = go n (cur * 2)
      | n == cur = cur
      | otherwise = cur `div` 2

solveC :: Int -> [(Int, Int)] -> Bool
solveC 0 [] = False
solveC n list =
  let edges = list ++ map (\(a, b) -> (b, a)) list
      graph = buildG (1, n) edges
      ans = filter (\(_, i) -> 1 `elem` i && n `elem` i) $ assocs graph
   in not (null ans)
