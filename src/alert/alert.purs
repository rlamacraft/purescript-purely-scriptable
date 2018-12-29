module PurelyScriptable.Alert (newAlert, presentAlert, message, setMessage, title, setTitle, addAction, addActions, Alert,
                               Button(..), TextField(..), addTextField, AlertResult(..), textFieldValue,
                               unsafeTextFieldValue, class Ask, ask, askIfNothing, present, closeButton, displayString, Close(..), askForString) where

import Control.Applicative (pure)
import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Data.Array (index, unsafeIndex)
import Data.Function ((#), ($))
import Data.Functor (map, (<#>))
import Data.List (List(..), singleton)
import Data.Maybe (Maybe(..), maybe)
import Data.Show (class Show, show)
import Effect (Effect)
import Effect.Aff (Aff)
import Optic.Getter(view)
import Optic.Lens (lens)
import Optic.Setter (set, concat)
import Optic.Types (Lens')
import Partial.Unsafe (unsafePartial)

data AlertResult b = Result (Button b) (Array String)

foreign import presentAlertImpl :: forall b . Show b => Alert b -> Effect (Promise (AlertResult b))

newtype Button b = Button b

instance showButton :: Show b => Show (Button b) where
  show (Button b) = show b

type Alert b = {
  _title :: Maybe String,
  _message :: Maybe String,
  buttons :: List (Button b),
  btnLabels :: List String,
  _textFields :: List TextField
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
  _title : Nothing,
  _message : Nothing,
  buttons : Nil,
  btnLabels : Nil,
  _textFields : Nil
}

presentAlert :: forall b . Show b => Alert b -> Aff (AlertResult b)
presentAlert = setBtnLabels >>> presentAlertImpl >>> toAffE

present :: forall b . Show b => Alert b -> Aff (AlertResult b)
present = presentAlert

message :: forall b . Lens' (Alert b) (Maybe String)
message = lens _._message (\a m -> a {_message = m})

setMessage :: forall b . String -> Alert b -> Alert b
setMessage msg = set message $ Just msg

title :: forall b . Lens' (Alert b)  (Maybe String)
title = lens _._title (\a t -> a {_title = t})

setTitle :: forall b . String -> Alert b -> Alert b
setTitle str = set title $ Just str

actionLabels :: forall b . Lens' (Alert b) (List String)
actionLabels = lens _.btnLabels (\a bls -> a {btnLabels = bls})

setBtnLabels :: forall b . Show b => Alert b -> Alert b
setBtnLabels a = set actionLabels (map show (view actions a)) a

actions :: forall b . Lens' (Alert b) (List (Button b))
actions = lens _.buttons (\alert bs -> alert {buttons = bs})

addAction :: forall b . Show b => Button b -> Alert b -> Alert b
addAction btn = addActions $ singleton btn

addActions :: forall b . Show b => List (Button b) -> Alert b -> Alert b
addActions = concat actions

textFields :: forall b . Lens' (Alert b) (List TextField)
textFields = lens _._textFields (\a ts -> a {_textFields = ts})

addTextField :: forall b . TextField -> Alert b -> Alert b
addTextField t = concat textFields $ singleton t

textFieldValue :: forall b . Int -> AlertResult b -> Maybe String
textFieldValue i (Result _ textFieldValues) = index textFieldValues i

unsafeTextFieldValue :: forall b . Partial => Int -> AlertResult b -> String
unsafeTextFieldValue i (Result _ textFieldValues) = unsafeIndex textFieldValues i

-----------------------
-- Helpers
-----------------------

data Close = Close

instance showClose :: Show Close where
  show Close = "Close"

closeButton :: Button Close
closeButton = Button Close

displayString :: String -> Aff (AlertResult Close)
displayString str = newAlert # setTitle str
                    >>> addAction closeButton
                    >>> presentAlert

-----------------------
-- Ask
-----------------------

class Ask a where
  ask :: String -> Aff a

askIfNothing :: forall a . Ask a => String -> Maybe a -> Aff a
askIfNothing alertTitle = maybe (ask alertTitle) pure

askForString :: String -> Aff String
askForString alertTitle = newAlert # setTitle alertTitle
          >>> addAction closeButton
          >>> addTextField {placeholder: Nothing, text: Nothing}
          >>> presentAlert
          <#> unsafePartial (unsafeTextFieldValue 0)

instance askString :: Ask String where
  ask = askForString

