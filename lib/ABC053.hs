module ABC053 where

import qualified Data.Array.Unboxed as U

solveA :: Int -> String
solveA x = if x < 1200 then "ABC" else "ARC"

-- convert s to Array
-- Loop from 1 to length s
solveB :: String -> Int
solveB s =
  let ar :: U.UArray Int Char
      ar = U.listArray (1, length s) s
   in last [i | i <- [1 .. length s], ar U.! i == 'Z'] - head [i | i <- [1 .. length s], ar U.! i == 'A'] + 1

-- solveC :: Int -> Int
-- solveC x = (x `div` 11) * 2 + if (x `mod` 11) >= 7 then 2 else 1
solveC :: Integer -> Integer
solveC x =
  let q = x `div` 11
      r = x `mod` 11
   in q * 2 + case r of
        0 -> 0
        _
          | r <= 6 -> 1
          | otherwise -> 2
