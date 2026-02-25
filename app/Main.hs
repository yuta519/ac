module Main (main) where

import ABC175
import IOUtils

main :: IO ()
main = do
  [x, k, d] <- getInts

  print $ solveC x k d
