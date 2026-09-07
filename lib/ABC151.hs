module ABC151 where

import Data.Char (chr, ord)

solveA :: Char -> Char
solveA c = chr $ ord c + 1
