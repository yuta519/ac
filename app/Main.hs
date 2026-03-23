module Main (main) where

import ABC099
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  print $ solveB a b
