{-# LANGUAGE OverloadedStrings #-}
module Backend.Scraper where

import Text.HTML.Scalpel

import Data.Aeson ( object, KeyValue((.=)), ToJSON(toJSON) )

data Offer = Offer {
    title :: String,
    price :: String,
    description :: String
}

instance ToJSON Offer where
 toJSON (Offer title price description) =
    object [ "title" .= title
           , "price" .= price
           , "description" .= description
             ]
             
instance Show Offer where
    show (Offer title price description) = "Title: " ++ show title ++ " | Price: " ++ show price ++ " | Description : " ++ show description ++ " \n"

titles :: IO (Maybe [Offer])
titles = scrapeURL "https://www.morizon.pl/do-wynajecia/mieszkania/najnowsze/warszawa/" offers where
    offers:: Scraper String [Offer]
    offers = chroots (TagString "section" @: [hasClass "single-result__content"]) offer

    offer :: Scraper String Offer
    offer = do
        title      <- text $ TagString "h2" @: [hasClass "single-result__title"]
        price <- text $ TagString "p"  @: [hasClass "single-result__price"]
        description <- text $ TagString "div" @: [hasClass "single-result__description"]
        return $ Offer title price description