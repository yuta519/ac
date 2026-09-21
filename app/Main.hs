module Main (main) where

import ABC153
import IOUtils

main :: IO ()
main = do
  [h, _] <- getInts
  as <- getInts

  putStrLn $ solveB h as
