module ABC098 where

import Data.List
import qualified Data.Set as Set

solveA :: Int -> Int -> Int
solveA a b = maximum [a + b, a - b, a * b]

solveB :: String -> Int
solveB s = maximum $ zipWith (\l r -> Set.size $ Set.intersection l r) left right
  where
    left = scanl' (\set c -> Set.insert c set) Set.empty s
    right = scanr (\c set -> Set.insert c set) Set.empty s

solveC :: String -> Int
solveC s = minimum $ zipWith (+) left right
  where
    ws acc c = acc + if c == 'W' then 1 else 0
    es c acc = acc + if c == 'E' then 1 else 0
    left = scanl' ws 0 s
    right = tail $ scanr es 0 s
