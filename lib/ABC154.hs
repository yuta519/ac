module ABC154 where

solveA :: (String, Int) -> (String, Int) -> String -> (Int, Int)
solveA (s, sCount) (t, tCount) u = if s == u then (sCount - 1, tCount) else (sCount, tCount - 1)

solveB :: String -> String
solveB s = ['x' | _ <- [1 .. (length s)]]
