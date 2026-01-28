module Main (main) where

import ABC083
import IOUtils

main :: IO ()
main = do
  [a, b, c, d] <- getInts
  putStrLn $ solveA (a, b, c, d)
