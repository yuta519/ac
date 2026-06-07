module Main (main) where

import ABC136
import IOUtils

main :: IO ()
main = do
  _ <- getLine
  hs <- getInts

  putStrLn $ if solveC hs then "Yes" else "No"
