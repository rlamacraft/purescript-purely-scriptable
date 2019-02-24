module PurelyScriptable
  ( run
  , runWithErrorLogging
  ) where

import Control.Applicative (pure)
import Control.Semigroupoid ((>>>))
import Data.Either (either)
import Data.Functor (map)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff, attempt, launchAff_)
import Effect.Exception (throwException)

run :: forall a . Aff a -> Effect Unit
run = launchAff_

runWithErrorLogging :: forall a . Aff a -> Effect Unit
runWithErrorLogging = attempt >>> map (either throwException pure) >>> launchAff_
