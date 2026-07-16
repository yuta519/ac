module ABC085 where

import Data.Array (accumArray, elems)
import Data.Sequence (fromArray)

solveB :: [Int] -> Int
solveB d = length $ filter id $ elems $ accumArray (||) False (1, 100) [(x, True) | x <- d]
