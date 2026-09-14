module Main (main) where

import ABC152
import IOUtils

main :: IO ()
main = do
  [n, m] <- getInts

  putStrLn $ solveA n m
