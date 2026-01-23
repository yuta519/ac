module Main (main) where

import ABC061
import IOUtils

main :: IO ()
main = do
  [a, b, c] <- getInts
  putStrLn $ if solveA (a, b, c) then "Yes" else "No"
