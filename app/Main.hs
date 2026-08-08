module Main (main) where

import ABC146
import IOUtils

main :: IO ()
main = do
  s <- getLine

  print $ solveA s
