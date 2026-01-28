module ABC083 where

solveA :: (Int, Int, Int, Int) -> String
solveA (a, b, c, d)
  | a + b > c + d = "Left"
  | a + b < c + d = "Right"
  | a + b == c + d = "Balanced"

solveB :: Int -> Int -> Int -> Int
solveB n a b = sum [i | i <- [a .. n], (base10 i) >= a && (base10 i) <= b]

base10 :: Int -> Int
base10 i = if i >= 10 then (i `mod` 10) + base10 (i `div` 10) else i
