module Main (main) where

import ABC136
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts

  print $ solveA a b c
