module ABC158 where

solveA :: String -> String
solveA [x] = "No"
solveA (x : y : zs) = if x /= y then "Yes" else solveA (y : zs)
