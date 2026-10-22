module Main (main) where

import ABC157
import IOUtils

main :: IO ()
main = do
  n <- getInt

  print $ solveA n
