module Main (main) where

import ABC097
import IOUtils

main :: IO ()
main = do
  x <- getInt

  print $ solveB x
