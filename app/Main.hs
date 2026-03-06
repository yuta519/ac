module Main (main) where

import ABC204
import IOUtils

main :: IO ()
main = do
  [x, y] <- getInts

  print $ solveA x y
