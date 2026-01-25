module Typical10 where

import Data.Array

solve :: Int -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
solve n cp lr =
  let firstClass = listArray (1, n) $ [if c == 1 then p else 0 | (c, p) <- cp]
      secondClass = listArray (1, n) $ [if c == 2 then p else 0 | (c, p) <- cp]
      firstCs = listArray (0, n) $ scanl (+) 0 (elems firstClass)
      secondCs = listArray (0, n) $ scanl (+) 0 (elems secondClass)
   in [(firstCs ! r - firstCs ! (l - 1), secondCs ! r - secondCs ! (l - 1)) | (l, r) <- lr]
