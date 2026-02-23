module Main (main) where

import AGC010
import IOUtils

main :: IO ()
main = do
  _ <- getInt
  as <- getLine

  putStrLn $ solveA $ map read (words as)
