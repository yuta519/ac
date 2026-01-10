module IOUtils (getInt, getInts, getLineXTimes, readMultiLinesFile) where

import Control.Monad

getInt :: IO (Int)
-- getInt = read <$> getLine
getInt = fmap read getLine

getInts :: IO [Int]
getInts = fmap read <$> words <$> getLine

getLineXTimes :: Int -> IO [String]
-- getLineXTimes x = sequence $ replicate x getLine
getLineXTimes x = replicateM x getLine

readMultiLinesFile :: String -> IO [String]
readMultiLinesFile filename = lines <$> readFile filename
