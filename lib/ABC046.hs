module ABC046 where

import qualified Data.Set as Set

solveA :: Int -> Int -> Int -> Int
solveA a b c = length $ Set.fromList [a, b, c]
