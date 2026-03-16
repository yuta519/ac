module Main (main) where

import ABC045
import IOUtils

main :: IO ()
main = do
  a <- getLine
  b <- getLine
  c <- getLine

  putStrLn [solveB (a, b, c) 'a']
