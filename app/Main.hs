module Main (main) where

import ABC128
import IOUtils
import Text.Printf (printf)

main :: IO ()
main = do
  n <- getInt
  xs <- getLineXTimes n
  let xs' = [(a, read b) | x <- xs, let [a, b] = words x] :: [(String, Int)]

  mapM_ print $ solveB xs'
