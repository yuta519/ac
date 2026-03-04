module Main (main) where

import ABC175
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  ls <- getInts

  print $ solveB ls
