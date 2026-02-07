module ABC087 where

solveA :: Int -> Int -> Int -> Int
solveA x a b = (x - a) `mod` b

solveB :: Int -> Int -> Int -> Int -> Int
solveB a b c x = sum [1 | as <- [0 .. a], bs <- [0 .. b], cs <- [0 .. c], as * 500 + bs * 100 + cs * 50 == x]
