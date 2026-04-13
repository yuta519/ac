module Main (main) where

import ABC126
import IOUtils
import Text.Printf (printf)

main :: IO ()
main = do
  [n, k] <- getInts
  printf "%.12f\n" (solveC n k)
