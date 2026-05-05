module Main (main) where

import ABC133
import IOUtils

main :: IO ()
main = do
  [n, a, b] <- getInts

  print $ solveA n a b
