module Main (main) where

import ABC149

main :: IO ()
main = do
  [s, t] <- words <$> getLine

  putStrLn $ solveA s t
