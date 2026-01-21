module ABC086 where

import Data.List (foldl')

solveA :: Int -> Int -> String
solveA a b = if (a * b) `mod` 2 == 0 then "Even" else "Odd"

solveC :: [(Int, Int, Int)] -> Bool
solveC =
  fst . foldl' step (True, (0, 0, 0))
  where
    step (False, prev) _ = (False, prev)
    step (True, prev) curr = if canMove prev curr then (True, curr) else (False, prev)

canMove :: (Int, Int, Int) -> (Int, Int, Int) -> Bool
canMove (t1, x1, y1) (t2, x2, y2) =
  let dt = t2 - t1
      dist = abs (x2 - x1) + abs (y2 - y1)
   in dist <= dt && (dt - dist) `mod` 2 == 0
