module Main (main) where

import ABC131
import IOUtils

main :: IO ()
main = do
  n <- getInt
  inputs <- getLineXTimes n

  putStrLn $ solveD [let [a, b] = map read (words input) in (a, b) | input <- inputs]
