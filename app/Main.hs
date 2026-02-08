module Main (main) where

import ABC088
import IOUtils

main :: IO ()
main = do
  x <- getInt
  a <- getInt

  putStrLn $ if solveA x a then "Yes" else "No"
