module Main (main) where

import ABC122
import Control.Monad
import IOUtils

main :: IO ()
main = do
  [n, q] <- getInts
  s <- getLine
  xs <- getLineXTimes q
  let xs' = [(read a, read b) | x <- xs, let [a, b] = words x] :: [(Int, Int)]

  forM_ (solveC n s xs') print
