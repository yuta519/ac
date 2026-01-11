module Main (main) where

import ABC081
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  x <- getInts
  print $ solveB x
