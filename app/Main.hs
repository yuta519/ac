module Main (main) where

import ABC046
import IOUtils

main :: IO ()
main = do
  [n, k] <- getInts

  print $ solveB n k
