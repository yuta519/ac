module Main (main) where

import ABC134
import IOUtils

main :: IO ()
main = do
  r <- getInt

  print $ solveA r
