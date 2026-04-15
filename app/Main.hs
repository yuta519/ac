module Main (main) where

import ABC129
import IOUtils

main :: IO ()
main = do
  hours <- getInts

  print $ solveA hours
