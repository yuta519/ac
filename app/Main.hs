module Main (main) where

import ABC135
import IOUtils

main :: IO ()
main = do
  n <- getInt
  ps <- getInts

  let res = if solveB n ps then "YES" else "NO"
  putStrLn res
