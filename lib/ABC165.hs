module ABC165 where

solveA :: Int -> Int -> Int -> String
solveA k a b = if ceilDiv a k <= b `div` k then "OK" else "NG"
  where
    ceilDiv x y = (x + y - 1) `div` y
