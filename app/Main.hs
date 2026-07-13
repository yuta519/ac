module Main (main) where

import ABC141
import IOUtils

main :: IO ()
main = do
  [n, k, q] <- getInts
  a <- map read <$> getLineXTimes q

  mapM_ putStrLn $ solveC n k q a
