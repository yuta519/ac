module Main (main) where

import ABC053
import IOUtils

main :: IO ()
main = do
  x <- getInteger

  print $ solveC x
