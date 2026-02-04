module ABC065 where

import Data.Set

-- 3 1 2
-- 1 ()
-- 3 (1)
-- 2 (1, 3) -> Done
solveB :: [Int] -> Int
solveB as = go 1 0 empty
  where
    go cur steps visited
      | cur == 2 = steps
      | member cur visited = -1
      | otherwise = go (as !! (cur - 1)) (steps + 1) (insert cur visited)
