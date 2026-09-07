module Main (main) where

import ABC151
import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn [solveA (head s)]
