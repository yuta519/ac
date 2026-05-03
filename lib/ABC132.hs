module ABC132 where

import qualified Data.List as L
import qualified Data.Map as M

solveA :: String -> String
solveA s = if all (== 2) [freq | (_, freq) <- M.toList charFreq] then "Yes" else "No"
  where
    createCharMap m c = M.insertWith (+) c 1 m
    charFreq = L.foldl' createCharMap M.empty s
