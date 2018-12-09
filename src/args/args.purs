module PurelyScriptable.Args (ArgsText(..), argsText) where

import Data.Functor ((<#>))
import PurelyScriptable.Alert (class Ask, ask)

newtype ArgsText = ArgsText String

foreign import argsText :: Array ArgsText

instance askArgsText :: Ask ArgsText where
  ask alertTitle = ask alertTitle <#> ArgsText
