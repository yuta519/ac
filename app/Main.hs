module Main (main) where

import ABC137
import IOUtils

main :: IO ()
main = do
  n <- getInt
  ss <- getLineXTimes n

  print $ solveC ss
