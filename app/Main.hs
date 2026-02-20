module Main (main) where

import ABC109
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  putStrLn $ solveA a b
