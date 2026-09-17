module Main (main) where

import ABC152
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveB a b
