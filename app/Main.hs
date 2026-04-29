module Main (main) where

import ABC131
import IOUtils

main :: IO ()
main = do
  [n, l] <- getInts

  print $ solveB n l
