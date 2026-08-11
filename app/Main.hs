module Main (main) where

import ABC146
import IOUtils

main :: IO ()
main = do
  [a, b, x] <- getIntegers

  print $ solveC a b x
