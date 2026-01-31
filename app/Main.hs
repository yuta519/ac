module Main (main) where

import ABC085

-- import IOUtils

main :: IO ()
main = do
  s <- getLine
  putStrLn $ solveA s
