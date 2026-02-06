module Main (main) where

import ABC065
import IOUtils

main :: IO ()
main = do
  [x, a, b] <- getInts

  putStrLn $ solveA x a b
