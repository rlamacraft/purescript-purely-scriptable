module UITable (
  TextAlignment(..), Cell(..), Row(..), Header(..), Table(..), class Rowable, rowable, header, headings,
  text, singularString, centerAligned, leftAligned, rightAligned, present,
  toTable) where

import Control.Promise (Promise, toAffE)
import Data.Eq (class Eq)
import Data.Function ((>>>))
import Data.Functor (map)
import Data.Maybe (Maybe(..))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff)

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

newtype Row a = Row (Array Cell)
derive instance eqRow :: Eq (Row a)

newtype Header a = Header (Row a)
derive instance eqHeader :: Eq (Header a)

headings :: forall a . Array String -> Header a
headings = map singularString >>> Row >>> Header

-----------------------
-- UITable
-----------------------

data Table a = Table (Maybe (Header a)) (Array (Row a))
derive instance eqTable :: Eq  (Table a)

class Rowable a where
  rowable :: a -> Row a
  header :: Header a

toTable :: forall a . Rowable a => Array a -> Table a
toTable = map rowable >>> Table (Just header)

present :: forall a . Table a -> Aff Unit
present = present_Impl >>> toAffE

foreign import present_Impl :: forall a . Table a -> Effect (Promise Unit)
