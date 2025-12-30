module Main (main) where

import ABC044
import IOUtils

main :: IO ()
main = do
  n <- getInt
  k <- getInt
  x <- getInt
  y <- getInt

  print $ solveA n k x y
