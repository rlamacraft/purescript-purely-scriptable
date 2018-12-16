module ShareSheet (ShareSheetResult, presentAndWait) where

import Control.Promise (Promise, toAffE)
import Data.Function ((#))
import Data.Functor ((<#>))
import Effect (Effect)
import Effect.Aff (Aff)

data ShareSheetResult = Result Boolean

presentAndWait :: forall a . a -> Aff ShareSheetResult
presentAndWait activityItem = presentAndWaitImpl_single activityItem # toAffE <#> transformShareSheetResult

type ForeignShareSheetResult = {
  activity_type :: String,
  completed :: Boolean
}

foreign import presentAndWaitImpl_single :: forall a . a -> Effect (Promise ForeignShareSheetResult)

transformShareSheetResult :: ForeignShareSheetResult -> ShareSheetResult
transformShareSheetResult foreignResult = Result foreignResult.completed
