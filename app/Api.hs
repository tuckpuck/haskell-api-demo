module Main where
import Network.Wreq

main :: IO ()
-- main = putStrLn "Hello, Haskell!"
main = do
    rsp <- get "https://libretranslate.com/languages"
    print rsp