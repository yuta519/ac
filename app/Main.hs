module Main (main) where

import ABC148
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveC a b
