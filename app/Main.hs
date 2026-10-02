module Main (main) where

import ABC154
import IOUtils

main :: IO ()
main = do
  n <- getInt
  a <- getInts

  putStrLn $ solveC n a
