module Main (main) where

import ABC158
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveC a b
