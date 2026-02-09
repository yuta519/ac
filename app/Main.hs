module Main (main) where

import ABC053
import IOUtils

main :: IO ()
main = do
  x <- getInt

  putStrLn $ solveA x
