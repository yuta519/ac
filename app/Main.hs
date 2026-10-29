module Main (main) where

import ABC157
import Control.Monad (replicateM)
import IOUtils

main :: IO ()
main = do
  -- as <- replicateM 3 getInts
  -- n <- getInt
  -- bs <- replicateM n getInt
  -- putStrLn $ if solveB as bs then "Yes" else "No"

  [a, b] <- getInts

  print $ solveC a b
