module Main (main) where

import ABC043

-- import IOUtils

main :: IO ()
main = do
  s <- getLine
  let (start, end) = solveD s
  putStrLn $ show start ++ " " ++ show end
