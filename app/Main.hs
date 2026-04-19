module Main (main) where

import ABC129
import IOUtils

main :: IO ()
main = do
  [n, m] <- getInts
  as <- getLineXTimes m

  print $ solveC n ([read a | a <- as] :: [Int])
