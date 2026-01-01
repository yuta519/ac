module Main (main) where

import ABC061
import IOUtils

main :: IO ()
main = do
  [n, m] <- getInts
  roads <- getLineXTimes m
  mapM_ print $ solveB n [(a, b) | road <- roads, let [a, b] = fmap (read :: String -> Int) $ words road]
