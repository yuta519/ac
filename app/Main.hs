module Main (main) where

import ABC125
import IOUtils

main :: IO ()
main = do
  [a, b, t] <- getInts

  print $ solveA a b t
