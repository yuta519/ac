module Main (main) where

import ABC155
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  as <- getInts

  putStrLn $ solveB as
