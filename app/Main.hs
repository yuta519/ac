module Main (main) where

import ABC148
import IOUtils

main :: IO ()
main = do
  a <- getInt
  b <- getInt

  print $ solveA a b
