module Main (main) where

import ABC153
import IOUtils

main :: IO ()
main = do
  h <- getInt

  print $ solveD h
