module Main (main) where

import ABC130
import IOUtils

main :: IO ()
main = do
  [n, k] <- getInts
  as <- getInts

  print $ solveD n k as
