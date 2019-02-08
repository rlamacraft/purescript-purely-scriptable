-- | This module abstracts over the Scriptable `Request` APIs.
-- |
-- | Perform HTTP Requests, with embedded JSON deserilization using `Argonaut`.

module PurelyScriptable.Request
  ( Request(..)
  , URL
  , Body
  , Method(..)
  , Header
  , Headers
  , loadString
  , loadJSON
  , get
  , loadDecodable
  , collapseEither
  ) where

import Control.Applicative (pure)
import Control.Bind (bindFlipped)
import Control.Promise (Promise, toAffE)
import Data.Argonaut (class DecodeJson, Json, decodeJson)
import Data.Either (Either, either)
import Data.Function (const, (#), ($), (>>>))
import Data.Functor (map)
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Exception (throw)

type URL = String
type Body = String
data Method
  = GET
  | POST Body

method :: forall a . a -> (Body -> a) -> Method -> a
method getFunc _ GET = getFunc
method _ postFunc (POST body) = postFunc body
    
type Header = Tuple String String
type Headers = Array Header

data Request = Request Headers Method URL

methodToString :: Method -> String
methodToString = method "GET" (const "POST")

bodyToString :: Method -> Body
bodyToString = method "" (\a -> a)

loadString :: Request -> Aff String
loadString (Request headers m url) = loadString_Impl url (methodToString m) (bodyToString m) headers # toAffE

foreign import loadString_Impl :: URL -> String -> Body -> Headers -> Effect (Promise String)

loadJSON :: Request -> Aff Json
loadJSON (Request headers m url) = loadJSON_Impl url (methodToString m) (bodyToString m) headers # toAffE

foreign import loadJSON_Impl :: URL -> String -> Body -> Headers -> Effect (Promise Json)

loadDecodable :: forall a . DecodeJson a => Request -> Aff a
loadDecodable = loadJSON >>> map decodeJson >>> collapseEither

get :: URL -> Request
get = Request [] GET

collapseEither :: forall a . Aff (Either String a) -> Aff a
collapseEither = bindFlipped $ either (throw >>> liftEffect) pure
