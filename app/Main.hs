module Main (main) where

import ABC165
import IOUtils

main :: IO ()
main = do
  k <- getInt
  [a, b] <- getInts

  putStrLn $ solveA k a b
