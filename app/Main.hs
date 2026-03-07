module Main (main) where

import ABC204
import IOUtils

main :: IO ()
main = do
  _ <- getInt
  as <- getInts

  print $ solveB as
