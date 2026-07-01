module Main (main) where

import ABC140
import IOUtils

main :: IO ()
main = do
  n <- getInt

  print $ solveA n
