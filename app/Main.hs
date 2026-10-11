module Main (main) where

import ABC156
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  xs <- getInts

  print $ solveC xs
