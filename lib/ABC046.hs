module ABC046 where

import Data.List
import qualified Data.Set as Set

solveA :: Int -> Int -> Int -> Int
solveA a b c = length $ Set.fromList [a, b, c]

solveB :: Int -> Int -> Int
solveB n k = k * (k - 1) ^ (n - 1)

solveC :: [(Int, Int)] -> Int
solveC [] = 0
solveC (first : rest) = uncurry (+) $ foldl' go first rest
  where
    go (baseT, baseA) (curT, curA) =
      let kT = ceil baseT curT
          kA = ceil baseA curA
          k = max kT kA
       in (k * curT, k * curA)
    ceil x y = (x + y - 1) `div` y
