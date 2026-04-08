module Main (main) where

import ABC127
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveA a b
