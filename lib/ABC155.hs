module ABC155 where

import Data.Array.Unboxed
import Data.List (foldl', group, sort)

solveA :: Int -> Int -> Int -> String
solveA a b c
  | a == b && b == c = "No"
  | a == b || b == c || a == c = "Yes"
  | otherwise = "No"

solveB :: [Int] -> String
solveB as = if not violation then "APPROVED" else "DENIED"
  where
    violation = any (\x -> even x && x `mod` 3 /= 0 && x `mod` 5 /= 0) as

solveC :: [String] -> [String]
solveC ss = [head x | x <- sorted, max == length x]
  where
    sorted = group $ sort ss
    max = maximum [length x | x <- sorted]

-- | K-th smallest of the N(N-1)/2 pairwise products.
--
-- There are too many pairs to sort, so instead of producing the K-th value we
-- binary search it: @countLE x@ is non-decreasing in x, so the answer is the
-- smallest x whose count reaches k.
solveD :: [Int] -> Int -> Int
solveD as k = go (-limit) limit
  where
    limit = 10 ^ (18 :: Int)
    sorted = sort as
    negs = toArr $ filter (< 0) sorted
    poss = toArr $ filter (> 0) sorted
    n = length as
    z = n - arrLen negs - arrLen poss
    go lo hi
      | lo >= hi = lo
      | otherwise =
          let mid = (lo + hi) `div` 2
           in if countLE negs poss n z mid >= k then go lo mid else go (mid + 1) hi

-- | How many pairs have product <= x. Signs decide which end of a group
-- qualifies, so the four kinds of pair are counted separately and summed.
countLE :: UArray Int Int -> UArray Int Int -> Int -> Int -> Int -> Int
countLE negs poss n z x = zeroPairs + samePairs x negs + samePairs x poss + crossPairs
  where
    -- Every pair touching a zero has product exactly 0, so the whole block
    -- counts together, and only once x reaches 0.
    zeroPairs
      | x >= 0 = (n - z) * z + z * (z - 1) `div` 2
      | otherwise = 0
    crossPairs =
      foldl' (\acc i -> acc + partners x (negs ! i) poss) 0 [0 .. arrLen negs - 1]

-- | Unordered pairs drawn from a single group: count ordered pairs, drop the
-- i==j diagonal, then halve.
samePairs :: Int -> UArray Int Int -> Int
samePairs x v = (ordered - diagonal) `div` 2
  where
    len = arrLen v
    ordered = foldl' (\acc i -> acc + partners x (v ! i) v) 0 [0 .. len - 1]
    diagonal = length [() | i <- [0 .. len - 1], let a = v ! i, a * a <= x]

-- | How many b in the ascending array v satisfy @a * b <= x@. a is never 0
-- here, and its sign decides whether the qualifiers sit at the near or far end.
partners :: Int -> Int -> UArray Int Int -> Int
partners x a v
  -- a*b grows with b, so the qualifiers form a prefix ending where a*b passes x.
  | a > 0 = lowerBound (\i -> a * (v ! i) > x) len
  -- a*b shrinks as b grows, so the qualifiers form a suffix.
  | otherwise = len - lowerBound (\i -> a * (v ! i) <= x) len
  where
    len = arrLen v

-- | First position in [0..len] where p flips False to True, or len if never.
-- p must be monotone.
lowerBound :: (Int -> Bool) -> Int -> Int
lowerBound p len = go 0 len
  where
    go lo hi
      | lo >= hi = lo
      | otherwise =
          let mid = (lo + hi) `div` 2
           in if p mid then go lo mid else go (mid + 1) hi

arrLen :: UArray Int Int -> Int
arrLen v = snd (bounds v) - fst (bounds v) + 1

toArr :: [Int] -> UArray Int Int
toArr xs = listArray (0, length xs - 1) xs
