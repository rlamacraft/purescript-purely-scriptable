module Test.UITable where

import Control.Bind (discard)
import Control.Monad.Free (Free)
import Data.Eq ((==))
import Data.Function (($))
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Show (show)
import Data.Unit (Unit)
import Test.Unit (suite, test, TestF)
import Test.Unit.Assert (assert)
import UITable (class Rowable, Cell(..), Header(..), Table(..), TextAlignment(..), defaultRow, deriveStringRow, headings, rowable, singularString, toTable)

testUITable :: Free TestF Unit
testUITable = suite "UITable" do
  testToTable
  testDeriveStringRow


newtype MyString = MyString String
derive instance newtypeMyString :: Newtype MyString _

instance rowableMyString :: Rowable MyString where
  rowable = deriveStringRow
  header = headings []

testDeriveStringRow :: Free TestF Unit
testDeriveStringRow = suite "deriveStringRow" do
  test "equality with manual construction" do
    assert "" $ defaultRow [(Text (Just "foo") Nothing Left)] == (rowable $ MyString "foo")



data TestType = Test String Int

instance testRowable :: Rowable TestType where
  rowable (Test s i) = defaultRow [singularString s, singularString (show i)]
  header = headings ["string", "int"]

testToTable :: Free TestF Unit
testToTable = suite "toTable" do
  test "equality with manual construction" do
    assert "Rowable Test type" $ toTable [(Test "foo" 1)] == Table (Just (Header $ defaultRow [
                                                                       Text (Just "string") Nothing Left,
                                                                       Text (Just "int") Nothing Left
                                                                   ])) [defaultRow
                                                                       [
                                                                         Text (Just "foo") Nothing Left,
                                                                         Text (Just "1") Nothing Left
                                                                       ]] 
