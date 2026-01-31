module ABC085 where

import Data.List

solveA :: String -> String
solveA s = (take 3 s) ++ "8" ++ (drop 4 s)

solveA' :: String -> String
solveA' s =
  let year = (read $ take 4 s) + 1
      date = drop 4 s
   in show year ++ date

solveB :: [Int] -> Int
solveB xs = kagamiMochi $ nub $ sort xs

kagamiMochi :: [Int] -> Int
kagamiMochi [] = 0
kagamiMochi [a] = 1
kagamiMochi (a : b : xs) = (if a < b then 1 else 0) + kagamiMochi (b : xs)

solveC :: Int -> Int -> (Int, Int, Int)
solveC n y = case [(a, b, c) | a <- [0 .. n], b <- [0 .. (n - a)], let c = n - a - b, y == ((a * 10000) + (b * 5000) + (c * 1000))] of
  (x : _) -> x
  [] -> (-1, -1, -1)

{--
⚡ Even faster (O(n))
We can reduce to one loop using algebra:

  a*10000 + b*5000 + c*1000 = y
  a + b + c = n

Substitute c:
  9000a + 4000b = y - 1000n

Now:
  ⏱ O(n))
  💾 Constant memory
  🧠 Uses math insight
 - --}

solveC' :: Int -> Int -> (Int, Int, Int)
solveC' n y = go 0
  where
    target = y - 1000 * n
    go a
      | a > n = (-1, -1, -1)
      | (target - 9000 * a) `mod` 4000 /= 0 = go (a + 1)
      | otherwise =
          let b = (target - 9000 * a) `div` 4000
              c = n - a - b
           in if b >= 0 && c >= 0
                then (a, b, c)
                else go (a + 1)

-- Once a and b are fixed, c is determined So check the sum directly, no list needed
solveC'' :: Int -> Int -> (Int, Int, Int)
solveC'' n y = go 0 0
  where
    go a b
      | a > n = (-1, -1, -1)
      | b > n - a = go (a + 1) 0
      | a * 10000 + b * 5000 + (n - a - b) * 1000 == y =
          (a, b, n - a - b)
      | otherwise = go a (b + 1)
