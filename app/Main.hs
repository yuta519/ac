module Main (main) where

import ABC147
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts

  putStrLn $ solveA a b c
