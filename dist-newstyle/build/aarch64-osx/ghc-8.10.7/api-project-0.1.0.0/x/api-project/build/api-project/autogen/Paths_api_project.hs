{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_api_project (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/tbtriggs/.cabal/bin"
libdir     = "/Users/tbtriggs/.cabal/lib/aarch64-osx-ghc-8.10.7/api-project-0.1.0.0-inplace-api-project"
dynlibdir  = "/Users/tbtriggs/.cabal/lib/aarch64-osx-ghc-8.10.7"
datadir    = "/Users/tbtriggs/.cabal/share/aarch64-osx-ghc-8.10.7/api-project-0.1.0.0"
libexecdir = "/Users/tbtriggs/.cabal/libexec/aarch64-osx-ghc-8.10.7/api-project-0.1.0.0"
sysconfdir = "/Users/tbtriggs/.cabal/etc"

getBinDir     = catchIO (getEnv "api_project_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "api_project_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "api_project_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "api_project_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "api_project_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "api_project_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
