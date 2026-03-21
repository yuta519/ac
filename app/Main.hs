module Main (main) where

import ABC098
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveA a b
