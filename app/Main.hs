module Main (main) where

import ABC149
import IOUtils

main :: IO ()
main = do
  [a, b, k] <- getInts

  let (x, y) = solveB a b k
  putStrLn $ unwords [show x, show y]
