module Main (main) where

import Control.Monad
import IOUtils
import Typical10

main :: IO ()
main = do
  n <- getInt
  xs <- getLineXTimes n
  q <- getInt
  ys <- getLineXTimes q

  let cp = [(read c, read p) | [c, p] <- map words xs] :: [(Int, Int)]
      lr = [(read l, read r) | [l, r] <- map words ys] :: [(Int, Int)]

  forM_ (solve n cp lr) $ \(a, b) -> putStrLn $ show a ++ " " ++ show b
