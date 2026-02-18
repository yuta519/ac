module Main (main) where

import ABC089
import IOUtils

main :: IO ()
main = do
  n <- getInt
  names <- getLineXTimes n

  print $ solveC names
