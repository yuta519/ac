module Main (main) where

import ABC140
import IOUtils

main :: IO ()
main = do
  n <- getInt
  b <- getInts

  print $ solveC n b
