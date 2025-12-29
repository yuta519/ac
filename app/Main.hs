module Main (main) where

import ABC043
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  a <- getInts
  print $ solveC a
