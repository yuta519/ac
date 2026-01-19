module ABC049 where

import Data.List

solveA :: Char -> Bool
solveA s = case s of
  'a' -> True
  'e' -> True
  'i' -> True
  'o' -> True
  'u' -> True
  _ -> False

solveC :: String -> Bool
solveC s = go (reverse s)
  where
    go "" = True
    go s
      | "remaerd" `isPrefixOf` s = go $ drop 7 s
      | "maerd" `isPrefixOf` s = go $ drop 5 s
      | "resare" `isPrefixOf` s = go $ drop 6 s
      | "esare" `isPrefixOf` s = go $ drop 5 s
      | otherwise = False
