module Main (main) where

import ABC166

-- import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn $ solveA s
