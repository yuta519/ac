module ABC135 where

solveA :: Int -> Int -> Maybe Int
solveA a b
  | abs (a - b) `mod` 2 > 0 = Nothing
  | otherwise = Just $ abs (a - b) `div` 2 + min a b
