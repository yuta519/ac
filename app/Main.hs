module Main (main) where

import ABC137
import IOUtils

main :: IO ()
main = do
  [n, m] <- getInts
  ss <- getLineXTimes n

  let works = [(a, b) | s <- ss, let [a, b] = map read $ words s] :: [(Int, Int)]

  print $ solveD m works
