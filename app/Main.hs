module Main (main) where

import ABC049

main :: IO ()
main = do
  s <- getLine
  putStrLn $ if solveC s then "YES" else "NO"
