module Main (main) where

import ABC043

main :: IO ()
main = do
  s <- getLine
  putStrLn $ solveB s
