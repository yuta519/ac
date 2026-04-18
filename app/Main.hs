module Main (main) where

import ABC129
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  ws <- getInts

  print $ solveB ws
