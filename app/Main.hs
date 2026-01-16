module Main (main) where

import ABC085
import IOUtils

main :: IO ()
main = do
  n <- getInt
  as <- getLineXTimes n

  print $ solveB [read a :: Int | a <- as]
