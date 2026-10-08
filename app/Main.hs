module Main (main) where

import ABC156
import IOUtils

main :: IO ()
main = do
  [n, r] <- getInts

  print $ solveA n r
