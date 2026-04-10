module Main (main) where

import ABC127
import IOUtils

main :: IO ()
main = do
  [r, d, x2000] <- getInts
  mapM_ print $ solveB r d x2000
