module Main (main) where

import ABC133
import IOUtils

main :: IO ()
main = do
  [n, _] <- getInts
  xs <- getLineXTimes n

  print $ solveB [map read (words x) | x <- xs]
