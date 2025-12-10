module IOUtils (getLineXTimes) where

getLineXTimes :: Int -> IO [String]
getLineXTimes x = sequence $ replicate x getLine
