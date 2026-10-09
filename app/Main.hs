module Main (main) where

import ABC156
import IOUtils

main :: IO ()
main = do
  [n, k] <- getInts

  print $ solveB n k
