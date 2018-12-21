module ShareSheet (ShareSheetResult, presentAndWait, presentAndWaitMultiple, present, presentMultiple) where

import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Data.Unit(Unit)
import Effect (Effect)
import Effect.Aff (Aff)

type ShareSheetResult = {
  activity_type :: String,
  completed :: Boolean
}

-----------------------
-- ShareSheet API
-----------------------

presentAndWait :: forall a . a -> Aff ShareSheetResult
presentAndWait = presentAndWaitImpl_single >>> toAffE

foreign import presentAndWaitImpl_single :: forall a . a -> Effect (Promise ShareSheetResult)

presentAndWaitMultiple :: forall a . Array a -> Aff ShareSheetResult
presentAndWaitMultiple = presentAndWaitImpl_multiple >>> toAffE

foreign import presentAndWaitImpl_multiple :: forall a . Array a -> Effect (Promise ShareSheetResult)

present :: forall a . a -> Effect Unit
present = presentImpl_single

foreign import presentImpl_single :: forall a . a -> Effect Unit

presentMultiple :: forall a . Array a -> Effect Unit
presentMultiple = presentImpl_multiple

foreign import presentImpl_multiple :: forall a . Array a -> Effect Unit
