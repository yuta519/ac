module Main (main) where

import ABC043
import IOUtils (getInt)

main :: IO ()
main = do
  n <- getInt
  print $ solveA n
