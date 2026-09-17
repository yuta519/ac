module Main (main) where

import ABC151
import IOUtils

main :: IO ()
main = do
  [_, m] <- getInts
  lns <- getLineXTimes m
  let a = [(read $ head w, w !! 1) | l <- lns, let w = words l]
      (ac, wa) = solveC a

  putStrLn $ unwords [show ac, show wa]
