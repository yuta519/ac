module Main (main) where

import ABC046
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts

  print $ solveA a b c
