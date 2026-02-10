module Main (main) where

import ABC053
import IOUtils

main :: IO ()
main = do
  x <- getLine

  print $ solveB x
