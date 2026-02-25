module ABC175 where

solveC :: Integer -> Integer -> Integer -> Integer
solveC x k d
  | k <= (x' `div` d) = x' - k * d
  | even $ k - d' = m'
  | otherwise = abs (m' - d)
  where
    x' = abs x
    d' = x' `div` d
    m' = x' `mod` d
