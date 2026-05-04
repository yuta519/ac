module ABC132 where

import Data.List (foldl')
import Data.Map (empty, insertWith, toList)

solveA :: String -> String
solveA s = if all (== 2) [freq | (_, freq) <- toList charFreq] then "Yes" else "No"
  where
    createCharMap m c = insertWith (+) c 1 m
    charFreq = foldl' createCharMap empty s
