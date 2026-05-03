module Main (main) where

import ABC132
import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn $ solveA s
