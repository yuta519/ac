module Main (main) where

import ABC154
import IOUtils

main :: IO ()
main = do
  [_, k] <- getInts
  ps <- getInts

  print $ solveD k ps
