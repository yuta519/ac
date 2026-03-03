module Main (main) where

import ABC175

-- import IOUtils

main :: IO ()
main = do
  s <- getLine

  print $ solveA s
