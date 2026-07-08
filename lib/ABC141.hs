module ABC141 where

solveA :: String -> String
solveA s
  | s == "Sunny" = "Cloudy"
  | s == "Cloudy" = "Rainy"
  | s == "Rainy" = "Sunny"
