module Main (main) where

import ABC088
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  as <- getInts
  print $ solveB as
