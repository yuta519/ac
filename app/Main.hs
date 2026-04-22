module Main (main) where

import ABC130
import IOUtils

main :: IO ()
main = do
  [_, x] <- getInts
  ls <- getInts

  print $ solveB x ls
