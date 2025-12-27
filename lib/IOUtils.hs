module IOUtils (getLineXTimes, readMultiLinesFile) where

getLineXTimes :: Int -> IO [String]
getLineXTimes x = sequence $ replicate x getLine

readMultiLinesFile :: String -> IO [String]
readMultiLinesFile filename = lines <$> readFile filename
