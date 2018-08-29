
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

module WebSocketHandler.WsHandler
  (wsHandler, WsData(..), wsDataInit) where

import Common.Message

import Network.WebSockets.Snap
import Reflex.Dom.WebSocket.Server
import Reflex.Dom.WebSocket.Message
import qualified Data.Text as T
import Network.WebSockets
import Snap (MonadSnap, SnapletInit, makeSnaplet)

data WsData = WsData Text Int

wsDataInit :: SnapletInit b WsData
wsDataInit = makeSnaplet "ws" "ws snaplet" Nothing $ do
  return (WsData "t" 3)

wsHandler :: MonadSnap m => m ()
wsHandler = do
  liftIO $ putText "starting websocket handler"
  runWebSocketsSnap wsTop
  return ()

wsTop c = do
  conn <- acceptRequest c
  let loop = do
        d <- receiveData conn
        forkIO $ do
          resp <- handleRequest handler
            (\a b -> liftIO (showF a b)) d
          sendBinaryData conn resp
        loop

      showF :: (Show a, Show b) => a -> b -> IO ()
      showF a b = do
        putStrLn $ "Request: " ++ (show a)
        putStrLn $ "Response: " ++ (show b)
  liftIO $ loop

handler :: HandlerWrapper IO AppRequest
handler = HandlerWrapper $
  h getResp1
  :<&> h getResp2
  where
    h :: (WebSocketMessage AppRequest a, Monad m)
      => (a -> m (ResponseT AppRequest a))
      -> Handler m AppRequest a
    h = makeHandler

getResp1 :: Msg1 -> IO Msg1
getResp1 m = return $ "Resp from server: " <> m

getResp2 :: Msg2 -> IO Msg2
getResp2 _ = return 2
