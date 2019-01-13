module PurelyScriptable.CallbackURL (
  CallbackURL, URLParameters, URLParameter,
  getURL, newCallbackURL, addParameter, open
) where

import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Data.Array (null, (:))
import Data.Either (Either)
import Data.Bifoldable (bifoldMap)
import Data.Foldable (intercalate)
import Data.Function ((#))
import Data.Functor ((<#>))
import Data.Monoid(mempty)
import Data.Semigroup (append, (<>))
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
getURL c = c.target <> "://x-callback-url/" <> c.action <> joiner <> params where
  params = c.parameters <#> (bifoldMap (append mempty) (append "=")) # intercalate "&"
  joiner = if null c.parameters then "" else "?"

open :: CallbackURL -> Aff (Either Error String)
open = openImpl >>> toAffE >>> attempt

foreign import openImpl :: CallbackURL -> Effect (Promise String)

