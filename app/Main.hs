module Main (main) where

import ABC126
import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn $ solveB s
