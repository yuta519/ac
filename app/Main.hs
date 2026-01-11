module Main (main) where

import ABC086
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts
  putStrLn $ solveA a b
