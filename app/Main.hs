module Main (main) where

import ABC045
import IOUtils

main :: IO ()
main = do
  a <- getInt
  b <- getInt
  h <- getInt

  print $ solveA (a, b, h)
