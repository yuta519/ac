module Main (main) where

import ABC140
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  a <- getInts
  b <- getInts
  c <- getInts

  print $ solveB a b c
