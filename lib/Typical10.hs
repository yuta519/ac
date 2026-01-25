module Typical10 where

import Data.Array
import qualified Data.Array.Unboxed as U

solve :: Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
solve n cp lr =
  let firstClass = listArray (1, n) $ [if c == 1 then p else 0 | (c, p) <- cp]
      secondClass = listArray (1, n) $ [if c == 2 then p else 0 | (c, p) <- cp]
      firstCs = listArray (0, n) $ scanl (+) 0 (elems firstClass)
      secondCs = listArray (0, n) $ scanl (+) 0 (elems secondClass)
   in [(firstCs ! r - firstCs ! (l - 1), secondCs ! r - secondCs ! (l - 1)) | (l, r) <- lr]

-- https://atcoder.jp/contests/typical90/submissions/63911680
solve' n cps lrs = map fun lrs
  where
    fun (l, r) = (onecum U.! r - onecum U.! pred l, twocum U.! r - twocum U.! pred l)

    as :: U.UArray Int Int
    as = U.accumArray (+) 0 (1, n) [(i, p) | (i, (c, p)) <- zip [1 .. n] cps, c == 1]
    bs :: U.UArray Int Int
    bs = U.accumArray (+) 0 (1, n) [(i, p) | (i, (c, p)) <- zip [1 .. n] cps, c == 2]
    onecum :: U.UArray Int Int
    onecum = U.listArray (0, n) $ scanl (+) 0 (U.elems as)
    twocum :: U.UArray Int Int
    twocum = U.listArray (0, n) $ scanl (+) 0 (U.elems bs)
