-- | This module abstracts over the Scriptable `args` APIs.
-- |
-- | These are the arguments passed to the script when the script is executed from an action
-- | extension.
-- |
-- | An Ask implementation is provided so that when the script is not executed from an action
-- | extension the required data may easily be requested from the user.

module PurelyScriptable.Args
   ( ArgsText
   , argsText
   ) where

import Data.Functor ((<#>))
import PurelyScriptable.Alert (class Ask, ask)

newtype ArgsText = ArgsText String

foreign import argsText :: Array ArgsText

instance askArgsText :: Ask ArgsText where
  ask alertTitle = ask alertTitle <#> ArgsText
