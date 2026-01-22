module Main (main) where

import ABC049
import Control.Monad
import IOUtils

main :: IO ()
main = do
  [h, _w] <- getInts
  xs <- getLineXTimes h
  forM_ (solveB xs) putStrLn
