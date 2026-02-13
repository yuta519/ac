module Main (main) where

import ABC165
import IOUtils

main :: IO ()
main = do
  [a, b, n] <- getInts

  print $ solveD a b n
