module Main (main) where

import ABC098
import IOUtils

main :: IO ()
main = do
  _ <- getInt
  s <- getLine

  print $ solveC s
