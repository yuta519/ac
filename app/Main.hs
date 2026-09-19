module Main (main) where

import ABC152
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  ps <- getInts

  print $ solveC ps
