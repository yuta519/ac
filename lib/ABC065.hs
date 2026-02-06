module ABC065 where

import qualified Data.Array.Unboxed as U
import Data.Set

solveA :: Int -> Int -> Int -> String
solveA x a b
  | a >= b = "delicious"
  | x + a >= b = "safe"
  | otherwise = "dangerous"

-- 3 1 2
-- 1 ()
-- 3 (1)
-- 2 (1, 3) -> Done
solveB :: [Int] -> Int
solveB as = go 1 0 empty
  where
    arr :: U.UArray Int Int
    arr = U.listArray (1, (length as)) as
    go cur steps visited
      | cur == 2 = steps
      | member cur visited = -1
      | otherwise = go (arr U.! cur) (steps + 1) (insert cur visited)
