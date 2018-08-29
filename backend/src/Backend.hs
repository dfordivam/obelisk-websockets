{-# language OverloadedStrings #-}
module Backend where

import Common.Api
import Frontend
import qualified Obelisk.Backend as Ob

import Control.Lens
import qualified Data.ByteString.Char8 as BSC8
import Data.Default (Default (..))
import Obelisk.Asset.Serve.Snap (serveAssets)
import Obelisk.Snap
import Reflex.Dom
import System.IO (hSetBuffering, stderr, BufferMode (..))
import Snap (httpServe, defaultConfig, commandLineConfig, route)
import Snap.Internal.Http.Server.Config (Config (accessLog, errorLog), ConfigLog (ConfigIoLog))

backend :: IO ()
backend = do
  -- Make output more legible by decreasing the likelihood of output from
  -- multiple threads being interleaved
  hSetBuffering stderr LineBuffering

  -- Get the web server configuration from the command line
  cmdLineConf <- commandLineConfig defaultConfig
  headHtml <- fmap snd $
    renderStatic $ fst frontend
  let httpConf = cmdLineConf
        { accessLog = Just $ ConfigIoLog BSC8.putStrLn
        , errorLog = Just $ ConfigIoLog BSC8.putStrLn
        }
      appCfg = def & appConfig_initialHead .~ headHtml
  -- Start the web server
  httpServe httpConf $ route
    [ ("", serveApp "" appCfg)
    , ("", serveAssets "frontend.jsexe.assets" "frontend.jsexe") --TODO: Can we prevent naming conflicts between frontend.jsexe and static?
    , ("", serveAssets "static.assets" "static")
    ]
