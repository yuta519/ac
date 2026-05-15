module Main (main) where

import ABC134
import IOUtils

main :: IO ()
main = do
  [n, d] <- getInts

  print $ solveB n d
