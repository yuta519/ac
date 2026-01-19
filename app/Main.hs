module Main (main) where

import ABC049

-- import IOUtils

main :: IO ()
main = do
  [s] <- getLine
  putStrLn $ if solveA s then "vowel" else "consonant"
