module ABC068 where

import Data.Array
import Data.Graph
import qualified Data.IntSet as S

solveC :: Int -> [(Int, Int)] -> Bool
solveC 0 [] = False
solveC n boats =
  let edges = boats ++ map (\(a, b) -> (b, a)) boats
      graph = buildG (1, n) edges
      fromFirst = graph ! 1
      fromN = S.fromList (graph ! n)
   in any (`S.member` fromN) fromFirst

neighboarsOfX :: [(Int, Int)] -> Int -> [Int]
neighboarsOfX edges x = concatMap (\(a, b) -> [b | a == x] ++ [a | b == x]) edges
