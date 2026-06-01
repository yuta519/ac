module Main (main) where

import ABC134
import Control.Monad (forM_)
import IOUtils

main :: IO ()
main = do
  n <- getInt
  as <- getLineXTimes n

  let res = solveC $ map read as :: [Int]
  forM_ res print
