module Main (main) where

import ABC150
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  s <- getLine

  print $ solveB s
