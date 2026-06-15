module Main (main) where

import ABC138
import IOUtils

main :: IO ()
main = do
  _ <- getInt
  as <- getInts

  print $ solveB as
