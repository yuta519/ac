module Main (main) where

import ABC125
import IOUtils

main :: IO ()
main = do
  _ <- getInt
  as <- getInts

  print $ solveD as
