module Main (main) where

import ABC144
import IOUtils

main :: IO ()
main = do
  n <- getInteger

  print $ solveC n
