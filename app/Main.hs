module Main (main) where

import ABC154
import IOUtils

main :: IO ()
main = do
  [s, t] <- words <$> getLine
  [s_c, t_c] <- getInts
  target <- getLine

  let (a_s, a_t) = solveA (s, s_c) (t, t_c) target
  putStrLn $ unwords [show a_s, show a_t]
