module Main (main) where

import ABC139
import IOUtils

main :: IO ()
main = do
  n <- getInt

  print $ solveD n
