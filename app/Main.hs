module Main (main) where

import ABC147

-- import IOUtils

main :: IO ()
main = do
  s <- getLine

  print $ solveB s
