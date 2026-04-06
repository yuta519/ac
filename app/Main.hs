module Main (main) where

import ABC126
import IOUtils

main :: IO ()
main = do
  [_, k] <- getInts
  s <- getLine

  putStrLn $ solveA k s
