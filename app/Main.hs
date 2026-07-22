module Main (main) where

import ABC143
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveA a b
