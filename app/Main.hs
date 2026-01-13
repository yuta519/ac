module Main (main) where

import ABC083
import IOUtils

main :: IO ()
main = do
  [n, a, b] <- getInts
  print $ solveB n a b
