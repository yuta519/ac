module Main (main) where

import ABC131
import IOUtils

main :: IO ()
main = do
  passcode <- getLine

  putStrLn $ solveA passcode
