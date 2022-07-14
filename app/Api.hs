module Main where
import Network.Wreq

main :: IO ()
-- main = putStrLn "Hello, Haskell!"
main = do
    rsp <- get "https://translate.argosopentech.com/languages"
    print rsp