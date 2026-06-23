module Main (main) where

import ABC139
import IOUtils

main :: IO ()
main = do
  s <- getLine
  t <- getLine

  print $ solveA s t
