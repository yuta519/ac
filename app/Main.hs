module Main (main) where

import ABC149
import IOUtils

main :: IO ()
main = do
  x <- getInt

  print $ solveC x
