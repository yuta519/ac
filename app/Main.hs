module Main (main) where

import ABC153
import IOUtils

main :: IO ()
main = do
  [h, a] <- getInts

  print $ solveA h a
