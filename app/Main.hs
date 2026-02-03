module Main (main) where

import AGC024
import IOUtils

main :: IO ()
main = do
  [a, b, c, k] <- getInts
  print $ solveA a b c k
