module Main (main) where

import ATC001
import Data.List (elemIndex)
import Data.Maybe (mapMaybe)
import IOUtils

main :: IO ()
main = do
  [h, _] <- getInts
  grid <- getLineXTimes h
  let start = findStart grid

  putStrLn $ if solveA start grid then "Yes" else "No"

findStart :: [String] -> (Int, Int)
findStart grid = head $ mapMaybe findStartInRow (zip [0 ..] grid)
  where
    findStartInRow :: (Int, String) -> Maybe (Int, Int)
    findStartInRow (x, row) = do
      y <- elemIndex 's' row
      pure (x, y)
