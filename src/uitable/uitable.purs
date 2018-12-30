module UITable (
  TextAlignment(..), Cell(..), Row(..), Table(..), class Rowable, rowable,
  text, singularString, centerAligned, leftAligned, rightAligned,
  toTable) where

import Data.Function ((>>>))
import Data.Functor (map)
import Data.Maybe (Maybe(..))
import Data.Eq (class Eq)

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

-----------------------
-- UITable
-----------------------

newtype Table a = Table (Array (Row a))
derive instance eqTable :: Eq  (Table a)

class Rowable a where
  rowable :: a -> Row a

toTable :: forall a . Rowable a => Array a -> Table a
toTable = map rowable >>> Table
