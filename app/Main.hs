module Main (main) where

import ABC068
import IOUtils

main :: IO ()
main = do
  n <- getInt
  putStrLn $ solveA n
