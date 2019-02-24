module PurelyScriptable.Common
  ( collapseEither
  ) where

import Control.Applicative (pure)
import Control.Bind (bindFlipped)
import Control.Semigroupoid ((>>>))
import Data.Either (Either, either)
import Data.Function (($))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Exception (throw)

collapseEither :: forall a . Aff (Either String a) -> Aff a
collapseEither = bindFlipped $ either (throw >>> liftEffect) pure
