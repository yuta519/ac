module Main (main) where

import ABC085
import IOUtils

main :: IO ()
main = do
  n <- getInt
  x <- getLineXTimes n
  let d = [read y | y <- x] :: [Int]

  print $ solveB d
