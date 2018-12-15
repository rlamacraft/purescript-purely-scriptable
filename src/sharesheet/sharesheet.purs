module ShareSheet (ShareSheetResult, presentAndWait) where

import Data.Functor ((<#>))
import Effect.Aff (Aff)

data ShareSheetResult = Result Boolean

presentAndWait :: forall a . a -> Aff ShareSheetResult
presentAndWait activityItems = presentAndWaitImpl activityItems <#> transformShareSheetResult

type ForeignShareSheetResult = {
  activity_type :: String,
  completed :: Boolean
}

foreign import presentAndWaitImpl :: forall a . a -> Aff ForeignShareSheetResult

transformShareSheetResult :: ForeignShareSheetResult -> ShareSheetResult
transformShareSheetResult foreignResult = Result foreignResult.completed
