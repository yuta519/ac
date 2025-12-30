module Main (main) where

import ABC044

-- import IOUtils

main :: IO ()
main = do
  w <- getLine

  putStrLn $ solveB w
