module PurelyScriptable.UITable (
  TextAlignment(..), Cell(..), ConfigurableNumber(..), ConfigurableColor(..), RowConfig(..), Row(..),
  Header(..), Table(..), class Rowable, rowable, defaultRow, header, headings, backgroundColor,
  text, singularString, deriveStringRow, centerAligned, leftAligned, rightAligned, 
  present, present_singleSelect, present_multiSelect, toTable
  ) where

import Color (Color)
import Control.Promise (Promise, toAffE)
import Data.Array (nubEq, singleton)
import Data.Eq (class Eq)
import Data.Function ((#), (>>>))
import Data.Functor (map)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff)
import PurelyScriptable.Color (ForeignConstructableColor, toForeignConstructable)

-----------------------
-- UITableCell
-----------------------

data TextAlignment = Left | Center | Right
derive instance eqTextAlignment :: Eq TextAlignment

data Cell
  = Text (Maybe String) (Maybe String) TextAlignment
derive instance eqCell :: Eq Cell

text :: String -> String -> Cell
text title subtitle = Text (Just title) (Just subtitle) Left

singularString :: String -> Cell
singularString str = Text (Just str) Nothing Left

centerAligned :: Cell -> Cell
centerAligned (Text title subtitle _) = Text title subtitle Center

leftAligned :: Cell -> Cell
leftAligned (Text title subtitle _) = Text title subtitle Left

rightAligned :: Cell -> Cell
rightAligned (Text title subtitle _) = Text title subtitle Right

-----------------------
-- UITableRow
-----------------------

type ConfigurableNumber = Maybe Number
type ConfigurableColor = Maybe ForeignConstructableColor

type RowConfig = {
  cellSpacing :: ConfigurableNumber,
  height :: ConfigurableNumber,
  backgroundColor :: ConfigurableColor
}

data Row a = Row RowConfig (Array Cell)
derive instance eqRow :: Eq (Row a)

newtype Header a = Header (Row a)
derive instance eqHeader :: Eq (Header a)

defaultRow :: forall a . Array Cell -> Row a
defaultRow = Row {
  cellSpacing : Nothing,
  height : Nothing,
  backgroundColor : Nothing
}

backgroundColor :: Color -> ConfigurableColor
backgroundColor = toForeignConstructable >>> Just

headings :: forall a . Array String -> Header a
headings = map singularString >>> defaultRow >>> Header

-----------------------
-- UITable
-----------------------

data Table a = Table (Maybe (Header a)) (Array (Row a))
derive instance eqTable :: Eq (Table a)

class Rowable a where
  rowable :: a -> Row a
  header :: Header a

deriveStringRow :: forall a . Newtype a String => a -> Row a
deriveStringRow = unwrap >>> singularString >>> singleton >>> defaultRow

toTable :: forall a . Rowable a => Array a -> Table a
toTable = map rowable >>> Table (Just header)

present :: forall a . Rowable a => Array a -> Aff Unit
present = toTable >>> present_Impl >>> toAffE

foreign import present_Impl :: forall a . Table a -> Effect (Promise Unit)

present_multiSelect :: forall a . Eq a => Rowable a => Array a -> Aff (Array a)
present_multiSelect as = present_multiSelect_Impl (toTable as) as # toAffE >>> map nubEq

foreign import present_multiSelect_Impl :: forall a . Table a -> Array a -> Effect (Promise (Array a))

present_singleSelect :: forall a . Rowable a => Array a -> Aff a
present_singleSelect as = present_singleSelect_Impl (toTable as) as # toAffE

foreign import present_singleSelect_Impl :: forall a . Table a -> Array a -> Effect (Promise a)
