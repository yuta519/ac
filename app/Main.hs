module Main (main) where

import ABC142
import IOUtils

main :: IO ()
main = do
  n <- getInt
  as <- getInts

  putStrLn . unwords . map show $ solveC n as
