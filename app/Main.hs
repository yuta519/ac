module Main (main) where

import ABC135
import IOUtils

main :: IO ()
main = do
  [a, b] <- getInts
  let res = solveA a b
  if res > 0 then print res else putStrLn "IMPOSSIBLE"
