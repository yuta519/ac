module Main (main) where

import ABC141

-- import IOUtils

main :: IO ()
main = do
  s <- getLine

  putStrLn $ if solveB s then "Yes" else "No"
