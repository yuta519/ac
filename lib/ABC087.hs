module ABC087 where

solveB :: Int -> Int -> Int -> Int -> Int
solveB a b c x = sum [1 | as <- [0 .. a], bs <- [0 .. b], cs <- [0 .. c], as * 500 + bs * 100 + cs * 50 == x]
