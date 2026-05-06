module Main (main) where

import ABC132
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  ps <- getInts

  print $ solveB ps
