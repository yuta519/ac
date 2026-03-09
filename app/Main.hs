module Main (main) where

import ABC163
import IOUtils

main :: IO ()
main = do
  [n, _] <- getInts
  as <- getInts

  print $ solveB n as
