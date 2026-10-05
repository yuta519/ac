module Main (main) where

import ABC155
import IOUtils

main :: IO ()
main = do
  x <- getInt
  ss <- getLineXTimes x

  mapM_ putStrLn $ solveC ss
