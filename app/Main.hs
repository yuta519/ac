module Main (main) where

import ABC087
import IOUtils

main :: IO ()
main = do
  x <- getInt
  a <- getInt
  b <- getInt

  print $ solveA x a b
