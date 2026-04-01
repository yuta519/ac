module Main (main) where

import ABC046
import IOUtils

main :: IO ()
main = do
  n <- getInt
  xs <- getLineXTimes n
  let elects = map ((\[a, b] -> (read a, read b)) . words) xs

  print $ solveC elects
