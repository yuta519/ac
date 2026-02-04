module Main (main) where

import ABC065
import IOUtils

main :: IO ()
main = do
  n <- getInt
  xs <- getLineXTimes n

  print $ solveB [read x | x <- xs]
