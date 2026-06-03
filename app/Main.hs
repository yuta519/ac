module Main (main) where

import ABC136
import IOUtils

main :: IO ()
main = do
  n <- getInt

  print $ solveB n
