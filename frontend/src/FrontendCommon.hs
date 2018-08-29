{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE LambdaCase #-}

module FrontendCommon
  ( module FrontendCommon
  , module X
  , module DOM
  )
  where

import Common.Message as X

import Protolude as X hiding (link, (&), list, Alt, to)
import Control.Lens as X ((.~), (^.), (?~), (^?), (%~), _1, _2, _3, _4, sets, each
  , _head, _Just, view, over, views, preview, (^..), to, mapped, forMOf_)
import Control.Lens.Indexed
import Control.Monad.Fix as X

import Reflex.Dom as X
import Reflex.Dom.WebSocket.Monad as X
import Reflex.Dom.WebSocket.Message as X
import Reflex.Time as X (delay)
import Data.Time.Clock as X
import Data.Time.Calendar as X
import qualified Data.Map as Map
import qualified Data.Text as T
import Data.These as X
import Data.Align as X

import Language.Javascript.JSaddle as X (call, eval)
import qualified GHCJS.DOM.DOMRectReadOnly as DOM
import qualified GHCJS.DOM.Element as DOM
import qualified GHCJS.DOM.Types as DOM
import qualified Data.List.NonEmpty as NE
import Data.List.NonEmpty (NonEmpty)

type AppMonadT t m = WithWebSocketT AppRequest t m
type AppMonad t m = (MonadWidget t m, DOM.MonadJSM m)
