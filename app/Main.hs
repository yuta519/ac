module Main (main) where

import ABC085
import IOUtils

main :: IO ()
main = do
  [n, y] <- getInts
  let (a, b, c) = solveC n y
  putStrLn $ show a ++ " " ++ show b ++ " " ++ show c
