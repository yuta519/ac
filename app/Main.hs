module Main (main) where

import ABC083
import IOUtils

main :: IO ()
main = do
  [x, y] <- getInts
  print $ solveC x y
