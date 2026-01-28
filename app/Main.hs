module Main (main) where

import ABC081
import IOUtils

main :: IO ()
main = do
  [_n, k] <- getInts
  as <- getInts
  print $ solveC k as
