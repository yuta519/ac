module AdventOfCode2025Day1 where

part1 :: [String] -> Int
part1 inputs = countZero inputs 50

countZero :: [String] -> Int -> Int
countZero [] _ = 0
countZero (x : xs) current = do
  let next = mod (current + (translateRotateToInt x)) 100
  (if (next == 0) then 1 else 0) + (countZero xs next)

translateRotateToInt :: String -> Int
translateRotateToInt (x : xs)
  | x == 'R' = read xs
  | x == 'L' = read ('-' : xs)
  | otherwise = 0
