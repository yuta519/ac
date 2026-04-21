module Main (main) where

import ABC130
import IOUtils

main :: IO ()
main = do
  [x, a] <- getInts

  print $ solveA x a
