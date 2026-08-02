module Main (main) where

import ABC145
import IOUtils

main :: IO ()
main = do
  n <- getInt

  print $ solveA n
