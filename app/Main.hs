module Main (main) where

import ABC155
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts

  putStrLn $ solveA a b c
