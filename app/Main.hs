module Main (main) where

import ABC122
import IOUtils

main :: IO ()
main = do
  s <- getLine

  print $ solveB s
