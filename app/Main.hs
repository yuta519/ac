module Main (main) where

import ABC166
import IOUtils

main :: IO ()
main = do
  [n, m] <- getInts
  heights <- getInts
  a <- getLineXTimes m
  let roads = [(\[x, y] -> (x, y)) $ map read $ words b | b <- a] :: [(Int, Int)]
  print $ solveC n heights roads
