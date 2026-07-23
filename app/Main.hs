module Main (main) where

import ABC143
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  ds <- getInts

  print $ solveB ds
