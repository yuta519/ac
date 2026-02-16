module Main (main) where

import ABC089
import IOUtils

main :: IO ()
main = do
  n <- getInt

  print $ solveA n
