module Main (main) where

import AGC020
import IOUtils

main :: IO ()
main = do
  [_, a, b] <- getInts

  putStrLn $ solveA a b
