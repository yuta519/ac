module Main (main) where

import ABC154
import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn $ solveB s
