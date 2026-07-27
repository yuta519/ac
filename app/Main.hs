module Main (main) where

import ABC143
import IOUtils

main :: IO ()
main = do
  n <- getInt
  s <- getLine

  print $ solveC n s
