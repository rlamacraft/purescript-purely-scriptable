module Test.UITable where

import Control.Monad.Free (Free)
import Data.Eq ((==))
import Data.Function (($))
import Data.Maybe (Maybe(..))
import Data.Show (show)
import Data.Unit (Unit)
import Test.Unit (suite, test, TestF)
import Test.Unit.Assert (assert)
import UITable (class Rowable, TextAlignment(..), Cell(..), Row(..), Table(..), singularString, toTable)

testUITable :: Free TestF Unit
testUITable = suite "UITable" do
  testToTable


data TestType = Test String Int

instance testRowable :: Rowable TestType where
  rowable (Test s i) = Row [singularString s, singularString (show i)]

testToTable :: Free TestF Unit
testToTable = suite "toTable" do
  test "equality with manual construction" do
    assert "Rowable Test type" $ toTable [(Test "foo" 1)] == Table [Row
                                            [
                                               Text (Just "foo") Nothing Left,
                                               Text (Just "1") Nothing Left
                                            ]] 
