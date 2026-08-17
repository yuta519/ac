module Main (main) where

import ABC147
import Control.Monad
import IOUtils

main :: IO ()
main = do
  n <- getInt
  xs <- replicateM n readTestimonies

  print $ solveC xs

-- Each person's block is a count followed by that many "x y" lines.
readTestimonies :: IO [(Int, Int)]
readTestimonies = do
  a <- getInt
  replicateM a readPair

readPair :: IO (Int, Int)
readPair = do
  ns <- getInts
  case ns of
    [x, y] -> pure (x, y)
    _ -> error "expected two integers"
