module Main (main) where

import ABC087
import IOUtils

main :: IO ()
main = do
  a <- getInt
  b <- getInt
  c <- getInt
  x <- getInt
  print $ solveB a b c x
