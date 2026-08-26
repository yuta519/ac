module Main (main) where

import ABC150
import IOUtils

main :: IO ()
main = do
  [k, x] <- getInts

  putStrLn $ solveA k x
