module Main (main) where

import ABC142
import IOUtils

main :: IO ()
main = do
  [_, k] <- getInts
  hs <- getInts

  print $ solveB k hs
