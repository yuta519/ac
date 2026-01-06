module ABC068 where

import Data.Array
import qualified Data.IntSet as S

solveC :: Int -> [(Int, Int)] -> Bool
solveC 0 [] = False
solveC n boats =
  let adj =
        accumArray
          (++)
          []
          (1, n)
          ([(a, [b]) | (a, b) <- boats] ++ [(b, [a]) | (a, b) <- boats])
      fromFirst = adj ! 1
      fromN = S.fromList (adj ! n)
   in any (`S.member` fromN) fromFirst

neighboarsOfX :: [(Int, Int)] -> Int -> [Int]
neighboarsOfX edges x = concatMap (\(a, b) -> [b | a == x] ++ [a | b == x]) edges
