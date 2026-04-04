module Main (main) where

import ABC047
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts

  putStrLn $ solveA a b c
