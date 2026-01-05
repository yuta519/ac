module ABC068 where

solveC :: Int -> [(Int, Int)] -> Bool
solveC 0 [] = False
solveC n boats =
  let fromFirst = neighboarsOfX boats 1
      fromN = neighboarsOfX boats n
   in any (`elem` fromN) fromFirst

neighboarsOfX :: [(Int, Int)] -> Int -> [Int]
neighboarsOfX edges x = concatMap (\(a, b) -> [b | a == x] ++ [a | b == x]) edges
