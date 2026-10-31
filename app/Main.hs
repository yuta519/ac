module Main (main) where

import ABC158
import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn $ solveA s
