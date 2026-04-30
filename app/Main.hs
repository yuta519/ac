module Main (main) where

import ABC131
import IOUtils

main :: IO ()
main = do
  [a, b, c, d] <- getIntegers

  print $ solveC a b c d
