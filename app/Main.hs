module Main (main) where

import ABC135
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts

  case solveA a b of
    Nothing -> putStrLn "IMPOSSIBLE"
    Just k -> print k
