module Main (main) where

import AGC030
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts

  print $ solveA (a, b, c)
