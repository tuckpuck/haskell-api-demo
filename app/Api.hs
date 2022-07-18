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

translateText :: Text -> Text -> Text -> IO Text
translateText sourceLang textToTranslate targetLang = do 
    rsp <- asJSON =<< post "https://translate.argosopentech.com/translate" (toJSON (TranslateRequest {
        q = textToTranslate,
        source = sourceLang,
        target = targetLang,
        format = "text"
    }))
    pure (translatedText (rsp ^. responseBody))


main :: IO ()
main = do
    T.putStrLn "What language do you want to translate from?"
    sourceLanguage <- T.getLine 
    T.putStrLn "What language do you want to translate to?"
    targetLanguage <- T.getLine 
    T.putStrLn "What text would you like to translate?"
    theTextToTranslate <- T.getLine 
    result <- translateText sourceLanguage theTextToTranslate targetLanguage
    T.putStrLn result