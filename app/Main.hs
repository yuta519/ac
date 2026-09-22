module Main (main) where

import ABC153
import IOUtils

main :: IO ()
main = do
  [_, k] <- getInts
  as <- getInts

  print $ solveC k as
