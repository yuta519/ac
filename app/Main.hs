module Main (main) where

import ABC148

main :: IO ()
main = do
  _ <- getLine
  [s, t] <- words <$> getLine

  putStrLn $ solveB s t
