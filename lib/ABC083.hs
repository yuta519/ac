module ABC083 where

solveB :: Int -> Int -> Int -> Int
solveB n a b = sum [i | i <- [a .. n], (base10 i) >= a && (base10 i) <= b]

base10 :: Int -> Int
base10 i = if i >= 10 then (i `mod` 10) + base10 (i `div` 10) else i
