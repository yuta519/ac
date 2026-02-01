module Main (main) where

import ABC086
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts
  putStrLn $ solveB a b
