module Main (main) where

import ABC137
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveA a b
