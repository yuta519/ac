module Main (main) where

import ABC204
import IOUtils

main :: IO ()
main = do
  [n, m] <- getInts
  inputs <- getLineXTimes m
  let list = [(\[x, y] -> (x, y)) $ map read $ words a | a <- inputs] :: [(Int, Int)]
  print $ solveC n list
