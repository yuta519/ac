module Main (main) where

import HelloWorld (say)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  print say
