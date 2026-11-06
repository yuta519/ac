module Main (main) where

import ABC159
import IOUtils

main :: IO ()
main = do
  [n, m] <- getInts

  print $ solveA n m
