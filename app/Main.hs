module Main (main) where

import AGC002
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  putStrLn $ solveA a b
