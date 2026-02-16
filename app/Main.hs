module Main (main) where

import ABC089
import IOUtils

main :: IO ()
main = do
  _ <- getInt
  s <- words <$> getLine

  putStrLn $ solveB s
