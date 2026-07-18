module Main (main) where

import ABC142
import IOUtils

main :: IO ()
main = do
  n <- getInt

  print $ solveA n
