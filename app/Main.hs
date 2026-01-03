module Main (main) where

import ABC163
import IOUtils

main :: IO ()
main = do
  n <- getInt
  as <- getInts
  mapM_ print $ solveC n as
