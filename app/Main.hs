module Main where

import Backend.Scraper
import Prelude

main :: IO ()
main = do
    res <- titles
    case res of 
        Just toShow -> print (map (\el -> toJSON el) toShow)
        Nothing -> undefined
