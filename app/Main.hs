module Main (main) where

import ABC138
import IOUtils

main :: IO ()
main = do
  a <- getInt
  s <- getLine

  putStrLn $ solveA a s
