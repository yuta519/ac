module Main (main) where

import ABC148
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  as <- getInts

  print $ solveD as
