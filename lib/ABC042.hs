module ABC042 (solveA, solveB, solveC) where

import Data.List (sort)
import Data.Maybe (catMaybes)
import Data.Set (Set)
import qualified Data.Set as Set
import Text.Read (readMaybe)

solveA :: String -> String
solveA syllables = if count 5 syls == 2 && count 7 syls == 1 then "YES" else "NO"
  where
    syls = stringsToInts [s | s <- words syllables]

count :: Int -> [Int] -> Int
count x xs = length $ filter (== x) xs

stringsToInts :: [String] -> [Int]
stringsToInts xs = catMaybes $ map readMaybe xs

solveB :: [String] -> String
solveB xs = concat $ sort xs

digits :: Int -> [Int]
digits n = map (read . (: [])) (show n)

outOfObsession :: Set Int -> Int -> Bool
outOfObsession dislikes n = all (not . (`Set.member` dislikes)) $ digits n

solveC :: [Int] -> Int -> Int
solveC dislikes n = head [m | m <- [n ..], outOfObsession (Set.fromList dislikes) m]
