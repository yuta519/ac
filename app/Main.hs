module Main (main) where

import ABC125
import IOUtils

main :: IO ()
main = do
  _ <- getInt
  ns <- getInts

  print $ solveC ns
