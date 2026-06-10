module Main (main) where

import ABC137
import IOUtils

main :: IO ()
main = do
  [k, x] <- getInts

  putStrLn $ unwords $ map show $ solveB k x
