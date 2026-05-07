module Main (main) where

import ABC132
import IOUtils

main :: IO ()
main = do
  n <- getInt
  ds <- getInts

  print $ solveC n ds
