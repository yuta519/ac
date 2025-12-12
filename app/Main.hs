module Main (main) where

import ABC042 (solveC)

-- import IOUtils (getLineXTimes)
--

main :: IO ()
main = do
  inputN <- getLine
  let (n, _) = case words inputN of
        (x : y : _) -> (x, y)
        (x : []) -> (x, "0")
        [] -> ("0", "0")
  inputDs <- getLine
  let dislikes = [read d :: Int | d <- words inputDs]

  print $ solveC dislikes (read n :: Int)
