{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where
import Network.Wreq
import Data.Text (Text)
import Data.Aeson
import GHC.Generics
import Control.Lens
import qualified Data.Text.IO as T

data TranslateRequest = TranslateRequest {
    q :: Text,
    source :: Text,
    target :: Text,
    format :: Text
} deriving (Generic)

instance ToJSON TranslateRequest

data TranslateResponse = TranslateResponse {
    translatedText :: Text
} deriving (Generic)

instance FromJSON TranslateResponse

main :: IO ()
main = do
    rsp <- asJSON =<< post "https://translate.argosopentech.com/translate" (toJSON (TranslateRequest {
        q = "Haskell is awesome",
        source = "en",
        target = "ja",
        format = "text"
    }))
    T.putStrLn (translatedText (rsp ^. responseBody))