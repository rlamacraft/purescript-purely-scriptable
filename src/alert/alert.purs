-- | This module abstracts over the Scriptable `Alert` APIs.
-- |
-- | Modal alerts can be constructed and presented, including both buttons and textfields.
-- |
-- | This module also provides a mechanism for defining a standard alert for requesting data
-- | from a user to instantiate a given type. The Ask type class provides this mechanism and
-- | is implemented for Strings. This abstraction allows for default instantiations of types,
-- | in the event of a Maybe's Nothing case, with the user providing the necessary data.

module PurelyScriptable.Alert
  ( Alert
  , Button(..)
  , TextField(..)
  , AlertResult(..)
  , Close(..)
  -- Constructors
  , newAlert
  , presentAlert
  , setMessage
  , setTitle
  , addAction
  , addActions
  , addTextField
  , closeButton
  -- Presenting
  , present
  , textFieldValue
  , unsafeTextFieldValue
  -- Ask
  , class Ask
  , ask
  , askIfNothing
  , displayString
  , askForString
  ) where

import Control.Applicative (pure)
import Control.Promise (Promise, toAffE)
import Control.Semigroupoid ((>>>))
import Data.Array (index, unsafeIndex)
import Data.Foldable (foldr)
import Data.Function (flip, (#), ($))
import Data.Functor ((<#>))
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..), maybe)
import Data.Show (class Show, show)
import Effect (Effect)
import Effect.Aff (Aff)
import Partial.Unsafe (unsafePartial)

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

presentAlert :: forall b . Show b => Alert b -> Aff (AlertResult b)
presentAlert = presentAlertImpl >>> toAffE

present :: forall b . Show b => Alert b -> Aff (AlertResult b)
present = presentAlert

setMessage :: forall b . String -> Alert b -> Alert b
setMessage msg alert = alert { message = Just msg }

setTitle :: forall b . String -> Alert b -> Alert b
setTitle title alert = alert { title = Just title }

addAction :: forall b . Show b => Button b -> Alert b -> Alert b
addAction btn@(Button btnValue) alert = alert { buttons = btn:alert.buttons,
                                                btnLabels = (show btnValue):alert.btnLabels}

addActions :: forall b . Show b => List (Button b) -> Alert b -> Alert b
addActions = flip $ foldr addAction

addTextField :: forall b . TextField -> Alert b -> Alert b
addTextField textField alert = alert { textFields = textField:alert.textFields }

textFieldValue :: forall b . Int -> AlertResult b -> Maybe String
textFieldValue i (Result _ textFieldValues) = index textFieldValues i

unsafeTextFieldValue :: forall b . Partial => Int -> AlertResult b -> String
unsafeTextFieldValue i (Result _ textFieldValues) = unsafeIndex textFieldValues i

data Close = Close

instance showClose :: Show Close where
  show Close = "Close"

closeButton :: Button Close
closeButton = Button Close

displayString :: String -> Aff (AlertResult Close)
displayString str = newAlert # setTitle str
                    >>> addAction closeButton
                    >>> presentAlert

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

