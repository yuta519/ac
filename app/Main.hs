module Main (main) where

import ABC128
import IOUtils

main :: IO ()
main = do
  [a, p] <- getInts
  print $ solveA a p
