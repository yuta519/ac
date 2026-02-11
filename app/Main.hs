module Main (main) where

import ABC122
import IOUtils

main :: IO ()
main = do
  [b] <- getLine

  putStrLn [solveA b]
