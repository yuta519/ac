module Main (main) where

import ABC133
import IOUtils

main :: IO ()
main = do
  [l, r] <- getInts

  print $ solveC l r
