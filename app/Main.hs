module Main (main) where

import ABC042 (solveA, solveB)
import IOUtils (getLineXTimes)

main :: IO ()
main = do
  input <- getLine
  let n = case words input of
        (x : _) -> x
        [] -> "0"
  inputs <- getLineXTimes $ read n
  putStrLn $ solveB inputs
