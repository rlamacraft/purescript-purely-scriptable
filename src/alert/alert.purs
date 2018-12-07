module PurelyScriptable.Alert (newAlert, presentAlert, setMessage, setTitle, addAction, Alert, Button(..), TextField(..), addTextField, AlertResult(..)) where

import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Data.List (List(Nil), (:))
import Data.Maybe (Maybe(..))
import Data.Show (class Show, show)
import Effect (Effect)
import Effect.Aff (Aff)

presentAlert :: forall b . Show b => Alert b -> Aff (AlertResult b)
presentAlert = presentAlertImpl >>> toAffE

data AlertResult b = Result (Button b) (Array String)

foreign import presentAlertImpl :: forall b . Show b => Alert b -> Effect (Promise (AlertResult b))

newtype Button b = Button b

type Alert b = {
  title :: Maybe String,
  message :: Maybe String,
  buttons :: List (Button b),
  btnLabels :: List String,
  textFields :: List TextField
}

type TextField = { 
  placeholder :: Maybe String,
  text :: Maybe String
}

newAlert :: forall b . Alert b
newAlert = {
  message : Nothing,
  title : Nothing,
  buttons : Nil,
  btnLabels : Nil,
  textFields : Nil
}

setMessage :: forall b . String -> Alert b -> Alert b
setMessage msg alert = alert { message = Just msg }

setTitle :: forall b . String -> Alert b -> Alert b
setTitle title alert = alert { title = Just title }

addAction :: forall b . Show b => Button b -> Alert b -> Alert b
addAction btn@(Button btnValue) alert = alert { buttons = btn:alert.buttons,
                                                btnLabels = (show btnValue):alert.btnLabels}

addTextField :: forall b . TextField -> Alert b -> Alert b
addTextField textField alert = alert { textFields = textField:alert.textFields }
