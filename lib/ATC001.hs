module ATC001 where

import Data.Array (Array, listArray, (!))
import qualified Data.Set as Set

-- | ATC001-A 深さ優先探索: starting from the 's' cell, can we reach 'g' moving
-- 4-directionally through non-wall cells? Classic grid DFS for reachability.
--
-- The search *threads* one `visited` set through every branch (see `go`): each
-- call returns the set it ended up with, and that set flows into the next
-- neighbour. So each cell is processed at most once — O(H*W*log(H*W)).
--
-- The earlier `||`-chain version handed the *same* pre-branch set to all four
-- neighbours, so a region explored by one branch was re-walked by the others:
-- fine on the samples, exponential on a full 500x500 grid. See
-- docs/topics/threading-state-through-recursion.md for the full write-up.
solveA :: (Int, Int) -> [String] -> Bool
solveA start grid = fst (explore start Set.empty)
  where
    h = length grid
    w = length (head grid)

    -- Flatten the grid into an array once, for O(1) lookups. `grid !! x !! y`
    -- is O(x + y) per probe, which alone is enough to TLE a large grid.
    cells :: Array (Int, Int) Char
    cells = listArray ((0, 0), (h - 1, w - 1)) (concat grid)

    inBounds (x, y) = 0 <= x && x < h && 0 <= y && y < w

    -- (reached the goal?, visited set after exploring from this cell).
    -- Returning the set is what lets sibling branches share progress.
    explore :: (Int, Int) -> Set.Set (Int, Int) -> (Bool, Set.Set (Int, Int))
    explore (x, y) visited
      | not (inBounds (x, y)) = (False, visited)
      | c == '#' = (False, visited)
      | Set.member (x, y) visited = (False, visited)
      | c == 'g' = (True, visited)
      | otherwise = go neighbors (Set.insert (x, y) visited)
      where
        c = cells ! (x, y)
        neighbors = [(x + dx, y + dy) | (dx, dy) <- dirs]

        -- Visit neighbours left to right, threading `visited` forward and
        -- short-circuiting the moment any branch reaches the goal. Passing
        -- `v'` (not `v`) to the next neighbour is the whole fix.
        go [] v = (False, v)
        go (n : ns) v = case explore n v of
          (True, v') -> (True, v')
          (False, v') -> go ns v'

    dirs :: [(Int, Int)]
    dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
