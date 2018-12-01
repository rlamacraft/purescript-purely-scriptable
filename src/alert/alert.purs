module PurelyScriptable.Alert (newAlert, presentAlert, setMessage, setTitle, addAction, Alert, Button(..), TextField(..), addTextField, AlertResult(..)) where

import Control.Bind ((>>=))
import Control.Promise (Promise, toAff)
import Data.List (List(Nil), (:))
import Data.Maybe (Maybe(..))
import Data.Semigroup ((<>))
import Data.Show (class Show, show)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)

presentAlert :: forall btnType . Show btnType => Alert btnType -> Aff (AlertResult btnType)
presentAlert alert = liftEffect (presentAlertImpl alert) >>= toAff

data AlertResult btnType = Result (Button btnType) (List String)

foreign import presentAlertImpl :: forall btnType . Show btnType => Alert btnType -> Effect (Promise (AlertResult btnType))

newtype Button btnType = Button btnType


instance showButton :: Show btnType => Show (Button btnType) where
  show (Button btnValue) = "Button<" <> show btnValue <> ">"

type Alert btnType = { title :: Maybe String,
                       message :: Maybe String,
                       buttons :: List (Button btnType),
                       btnLabels :: List String,
                       textFields :: List TextField
                     }

type TextField = { placeholder :: Maybe String,
                   text :: Maybe String
                 }

newAlert :: forall btnType . Alert btnType
newAlert = {message : Nothing, title : Nothing, buttons : Nil, btnLabels : Nil, textFields : Nil}

setMessage :: forall btnType . String -> Alert btnType -> Alert btnType
setMessage msg alert = alert { message = Just msg }

setTitle :: forall btnType . String -> Alert btnType -> Alert btnType
setTitle title alert = alert { title = Just title }

addAction :: forall btnType . Show btnType => Button btnType -> Alert btnType -> Alert btnType
addAction btn@(Button btnValue) alert = alert { buttons = btn:alert.buttons, btnLabels = (show btnValue):alert.btnLabels}

addTextField :: forall btnType . TextField -> Alert btnType -> Alert btnType
addTextField textField alert = alert { textFields = textField:alert.textFields }
