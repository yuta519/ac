module Main (main) where

import ABC143
import IOUtils

main :: IO ()
main = do
  n <- getInt
  ls <- getInts

  print $ solveD n ls
