{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
module Frontend where

import qualified Data.Text as T
import Reflex.Dom.Core

import FrontendCommon

import Common.Api
import Static

frontend :: (StaticWidget x (), Widget x ())
frontend = (head', body)
  where
    head' = el "title" $ text "Obelisk Minimal Example"
    body = topWidget

topWidget :: MonadWidget t m => m ()
topWidget = do
  let url = "ws://localhost:40149/websocket/"
  (_,wsConn) <- withWSConnection
    url
    never -- close event
    True -- reconnect
    widget

  return ()

widget :: AppMonad t m => AppMonadT t m ()
widget = do
  text "Welcome to Obelisk on WebSockets!"
  el "p" $ text commonStuff
  elAttr "img" ("src" =: static @"obelisk.jpg") blank
  ev <- button "Msg1"
  resp <- getWebSocketResponse (("req" :: Text) <$ ev)
  respDyn <- holdDyn "" resp
  display respDyn
