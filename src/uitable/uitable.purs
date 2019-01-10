module UITable (
  TextAlignment(..), Cell(..), Row(..), Header(..), Table(..), class Rowable, rowable, header, headings,
  text, singularString, deriveStringRow, centerAligned, leftAligned, rightAligned, present
  ) where

import Control.Promise (Promise, toAffE)
import Data.Array (singleton)
import Data.Eq (class Eq)
import Data.Function ((#), (>>>))
import Data.Functor (map)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
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
derive instance eqTable :: Eq (Table a)

class Rowable a where
  rowable :: a -> Row a
  header :: Header a

deriveStringRow :: forall a . Newtype a String => a -> Row a
deriveStringRow = unwrap >>> singularString >>> singleton >>> Row

toTable :: forall a . Rowable a => Array a -> Table a
toTable = map rowable >>> Table (Just header)

present :: forall a . Rowable a => Array a -> Aff Unit
present = toTable >>> present_Impl >>> toAffE

foreign import present_Impl :: forall a . Table a -> Effect (Promise Unit)

present_multiSelect :: forall a . Rowable a => Array a -> Aff (Array a)
present_multiSelect as = present_multiSelect_Impl (toTable as) as # toAffE

foreign import present_multiSelect_Impl :: forall a . Table a -> Array a -> Effect (Promise (Array a))

present_singleSelect :: forall a . Rowable a => Array a -> Aff a
present_singleSelect as = present_singleSelect_Impl (toTable as) as # toAffE

foreign import present_singleSelect_Impl :: forall a . Table a -> Array a -> Effect (Promise a)
