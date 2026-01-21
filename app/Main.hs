module Main (main) where

import ABC086
import IOUtils

main :: IO ()
main = do
  n <- getInt
  xs <- getLineXTimes n

  let points = [(read t, read x, read y) | line <- xs, let [t, x, y] = words line] :: [(Int, Int, Int)]

  putStrLn $ if solveC points then "Yes" else "No"
