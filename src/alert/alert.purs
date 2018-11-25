module PurelyScriptable.Alert (newAlert, presentAlert, setMessage, setTitle, addAction, Alert, Button(..)) where

import Prelude

import Control.Promise (Promise, toAff)
import Data.List (List(Nil), (:))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)

presentAlert :: forall btnType . Show btnType => Alert btnType -> Aff (Button btnType)
presentAlert alert = liftEffect (presentAlertImpl alert) >>= toAff

foreign import presentAlertImpl :: forall btnType . Show btnType => Alert btnType -> Effect (Promise (Button btnType))

newtype Button btnType = Button btnType

instance showButton :: Show btnType => Show (Button btnType) where
  show (Button btnValue) = "Button<" <> show btnValue <> ">"

type Alert btnType = { message :: Maybe String, title :: Maybe String, buttons :: List (Button btnType), btnLabels :: List String}

newAlert :: forall btnType . Alert btnType
newAlert = {message : Nothing, title : Nothing, buttons : Nil, btnLabels : Nil}

setMessage :: forall btnType . String -> Alert btnType -> Alert btnType
setMessage msg alert = alert { message = Just msg }

setTitle :: forall btnType . String -> Alert btnType -> Alert btnType
setTitle title alert = alert { title = Just title }

addAction :: forall btnType . Show btnType => Button btnType -> Alert btnType -> Alert btnType
addAction btn@(Button btnValue) alert = alert { buttons = btn:alert.buttons, btnLabels = (show btnValue):alert.btnLabels}