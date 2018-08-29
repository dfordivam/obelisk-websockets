{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}

{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module Common.Message where

import Reflex.Dom.WebSocket.Message

import qualified Data.Text as T
import Data.Text (Text)

type AppRequest
  = Msg1
  :<|> Msg2

type Msg1 = Text

type Msg2 = Int

instance WebSocketMessage AppRequest Msg1 where
  type ResponseT AppRequest Msg1 = Msg1

instance WebSocketMessage AppRequest Msg2 where
  type ResponseT AppRequest Msg2 = Msg2
