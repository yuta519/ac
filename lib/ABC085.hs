module ABC085 where

import Data.List

solveB :: [Int] -> Int
solveB xs = kagamiMochi $ sort xs

kagamiMochi :: [Int] -> Int
kagamiMochi [] = 0
kagamiMochi [a] = 1
kagamiMochi (a : b : xs) = (if a < b then 1 else 0) + kagamiMochi (b : xs)
