module ABC046 where

import Data.List
import qualified Data.Set as Set

solveA :: Int -> Int -> Int -> Int
solveA a b c = length $ Set.fromList [a, b, c]

solveB :: Int -> Int -> Int
solveB n k = k * (k - 1) ^ (n - 1)

solveC :: [(Int, Int)] -> (Int, Int)
solveC elects = foldl' go (1, 1) elects
  where
    go (baseT, baseA) (curT, curA)
      | baseT < curT && baseA < curA = (curT, curA)
      | baseT > curT && baseA < curA =
          let x = if baseT `mod` curT == 0 then baseT `div` curT else baseT `div` curT + 1
           in (x * curT, x * curA)
      | baseT < curT && baseA > curA =
          let x = if baseA `mod` curA == 0 then baseA `div` curA else baseA `div` curA + 1
           in (x * curT, x * curA)
      | baseT > curT && baseA > curA =
          let base = if baseT > baseA then baseT else baseA
              cur = if baseT > baseA then curT else curA
              x = if base `mod` cur == 0 then base `div` cur else base `div` cur + 1
           in (x * curT, x * curA)
