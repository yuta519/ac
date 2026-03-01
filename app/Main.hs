module Main (main) where

import AGC025

-- import IOUtils

main :: IO ()
main = do
  s <- getLine

  print $ solveA s
