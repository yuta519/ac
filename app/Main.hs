module Main (main) where

import ABC163
import IOUtils

main :: IO ()
main = do
  r <- (read <$> getLine) :: IO Float

  print $ solveA r
