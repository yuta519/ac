module Main (main) where

import ABC093
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts

  print $ solveC (a, b, c) 0
