module ShareSheet (Activity, present, presentMultiple) where

import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Effect (Effect)
import Effect.Aff (Aff)

newtype Activity = Activity String

present :: forall a . a -> Aff Activity
present = presentImpl_single >>> toAffE

foreign import presentImpl_single :: forall a . a -> Effect (Promise Activity)

presentMultiple :: forall a . Array a -> Aff Activity
presentMultiple = presentImpl_multiple >>> toAffE

foreign import presentImpl_multiple :: forall a . Array a -> Effect (Promise Activity)
