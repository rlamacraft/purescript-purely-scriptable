module PurelyScriptable.Alert (newAlert, presentAlert, setMessage, setTitle, addAction, Alert, Button(..), TextField(..), addTextField, AlertResult(..), textFieldValue, unsafeTextFieldValue) where

import Control.Applicative (pure)
import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Data.Array (index, unsafeIndex)
import Data.List (List(Nil), (:))
import Data.Maybe (Maybe(..), maybe)
import Data.Show (class Show, show)
import Effect (Effect)
import Effect.Aff (Aff)

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

-----------------------
-- Alert API
-----------------------

newAlert :: forall b . Alert b
newAlert = {
  message : Nothing,
  title : Nothing,
  buttons : Nil,
  btnLabels : Nil,
  textFields : Nil
}

presentAlert :: forall b . Show b => Alert b -> Aff (AlertResult b)
presentAlert = presentAlertImpl >>> toAffE

setMessage :: forall b . String -> Alert b -> Alert b
setMessage msg alert = alert { message = Just msg }

setTitle :: forall b . String -> Alert b -> Alert b
setTitle title alert = alert { title = Just title }

addAction :: forall b . Show b => Button b -> Alert b -> Alert b
addAction btn@(Button btnValue) alert = alert { buttons = btn:alert.buttons,
                                                btnLabels = (show btnValue):alert.btnLabels}

addTextField :: forall b . TextField -> Alert b -> Alert b
addTextField textField alert = alert { textFields = textField:alert.textFields }

textFieldValue :: forall b . Int -> AlertResult b -> Maybe String
textFieldValue i (Result _ textFieldValues) = index textFieldValues i

unsafeTextFieldValue :: forall b . Partial => Int -> AlertResult b -> String
unsafeTextFieldValue i (Result _ textFieldValues) = unsafeIndex textFieldValues i

-----------------------
-- Ask
-----------------------

class Ask a where
  ask :: Aff a

askIfNothing :: forall a . Ask a => Maybe a -> Aff a
askIfNothing = maybe ask pure
