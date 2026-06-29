module Main (main) where

import ABC139
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  hs <- getInts

  print $ solveC hs
