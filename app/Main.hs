module Main (main) where

import ABC151
import IOUtils

main :: IO ()
main = do
  [n, k, m] <- getInts
  as <- getInts

  print $ solveB n k m (sum as)
