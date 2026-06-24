module ATC001 where

import qualified Data.Set as Set

solveA :: (Int, Int) -> [String] -> Bool
solveA (x, y) map = dfs x y Set.empty
  where
    rowLen = length map
    colLen = length (map !! 0)

    dfs :: Int -> Int -> Set.Set (Int, Int) -> Bool
    dfs x y visited
      | x < 0 || rowLen <= x || y < 0 || colLen <= y = False
      | Set.member (x, y) visited = False
      | map !! x !! y == '#' = False
      | map !! x !! y == 'g' = True
      | otherwise =
          let visited' = Set.insert (x, y) visited
           in dfs (x + 1) y visited' || dfs (x - 1) y visited' || dfs x (y + 1) visited' || dfs x (y - 1) visited'
