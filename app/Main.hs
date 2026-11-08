module Main (main) where

import ABC159
import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn $ solveB s
