module Main (main) where

import ABC130
import IOUtils
import Text.Printf (printf)

main :: IO ()
main = do
  [w, h, x, y] <- getInts
  let (a, b) = solveC w h x y
  printf "%.6f %d\n" a b
