{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where
import Network.Wreq
import Data.Text (Text)
import Data.Aeson
import GHC.Generics
import Control.Lens
import qualified Data.Text.IO as T
import Control.Monad (forM_)

data TranslateRequest = TranslateRequest {
    q :: Text,
    source :: Text,
    target :: Text,
    format :: Text
} deriving (Generic)

instance ToJSON TranslateRequest

data Languages = Languages {
    code :: Text, 
    name :: Text
} deriving (Show, Generic)

instance FromJSON Languages

data TranslateResponse = TranslateResponse {
    translatedText :: Text
} deriving (Show, Generic)

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

getLanguages :: IO [Languages]
getLanguages = do 
    rsp <- asJSON =<< get "https://translate.argosopentech.com/languages"
    pure (rsp ^. responseBody)


main :: IO ()
main = do
    T.putStrLn "Available languages:"
    langs <- getLanguages
    forM_ langs $ \lang -> do
        result <- pure $ name lang <> ": "  <> code lang
        T.putStrLn result
    T.putStrLn "What language do you want to translate from?"
    sourceLanguage <- T.getLine 
    T.putStrLn "What language do you want to translate to?"
    targetLanguage <- T.getLine 
    T.putStrLn "What text would you like to translate?"
    theTextToTranslate <- T.getLine 
    result <- translateText sourceLanguage theTextToTranslate targetLanguage
    T.putStrLn result