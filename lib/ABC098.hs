module ABC098 where

import Data.List

solveC :: String -> Int
solveC s = minimum $ zipWith (+) left right
  where
    ws acc c = acc + if c == 'W' then 1 else 0
    es c acc = acc + if c == 'E' then 1 else 0
    left = scanl' ws 0 s
    right = tail $ scanr es 0 s
