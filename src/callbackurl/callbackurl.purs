-- | This module abstracts over the Scriptable `CallbackURL` APIs.
-- |
-- | For interfacing with other apps using the Callback URL standard.

module PurelyScriptable.CallbackURL
  ( CallbackURL
  , URLParameters
  , URLParameter
  , getURL
  , newCallbackURL
  , addParameter
  , open
  ) where

import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Data.Array ((:))
import Data.Either (Either)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff, attempt)
import Effect.Exception (Error)

type URLParameter = Tuple String String
type URLParameters = Array URLParameter
type CallbackURL = {
  target :: String,
  action :: String,
  parameters :: URLParameters
}

newCallbackURL :: String -> String -> CallbackURL
newCallbackURL target action = {
  target : target,
  action : action,
  parameters : []
}

addParameter :: String -> String -> CallbackURL -> CallbackURL
addParameter key value cb = cb {parameters = (Tuple key value) : cb.parameters}

getURL :: CallbackURL -> String
getURL = getURL_Impl

foreign import getURL_Impl :: CallbackURL -> String

open :: CallbackURL -> Aff (Either Error String)
open = open_Impl >>> toAffE >>> attempt

foreign import open_Impl :: CallbackURL -> Effect (Promise String)

