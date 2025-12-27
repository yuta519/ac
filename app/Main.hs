module Main (main) where

import AdventOfCode2025Day1 (part1)
import IOUtils (readMultiLinesFile)

main :: IO ()
main = do
  inputs <- readMultiLinesFile "inputs/adventofcode-2025-day.txt"
  print $ part1 inputs
