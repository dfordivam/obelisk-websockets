module Devel where

import Obelisk.Run

import Backend
import Frontend

main :: Int -> IO ()
main port = run 40149 backend frontend

