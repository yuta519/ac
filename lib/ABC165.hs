module ABC165 where

solveA :: Int -> Int -> Int -> String
solveA k a b = if ceilDiv a k <= b `div` k then "OK" else "NG"
  where
    ceilDiv x y = (x + y - 1) `div` y

solveD :: Int -> Int -> Int -> Int
solveD a b n =
  let b_1 = a * (b - 1) `div` b
      n_ = a * n `div` b
   in if b_1 > n_ then n_ else b_1
