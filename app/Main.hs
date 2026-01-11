module Main (main) where

import ABC081
import IOUtils

main :: IO ()
main = do
  s <- getInt
  print $ solveA s
