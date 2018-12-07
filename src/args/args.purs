module PurelyScriptable.Args (ArgsText, argsText) where

newtype ArgsText = ArgsText String

foreign import argsText :: Array ArgsText
