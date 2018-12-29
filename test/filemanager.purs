module Test.FileManager where

import Control.Bind (discard)
import Control.Monad.Free (Free)
import Data.Eq ((==))
import Data.Function (($))
import Data.Monoid (mempty)
import Data.Semigroup ((<>))
import Data.Unit (Unit)

import FileManager (joinPath, root, (/), filePath, fileNameAsString, fileExtensionAsString)
import Test.Unit (suite, test, TestF)
import Test.Unit.Assert (assert)

testFileManager :: Free TestF Unit
testFileManager = suite "FileManager" do
  testPathIsAMonoid
  testFileNameAsString
  testFileExtensionAsString

testPathIsAMonoid :: Free TestF Unit
testPathIsAMonoid = suite "Path is a Monoid" do
  test "associativity" do
    assert "Path conforms to the monoidal law of associativity" $ ((root / "a") <> (root / "b")) <> (root / "c") == (root / "a") <> ((root / "b") <> (root / "c"))
  test "identity" do
    assert "Path conforms on the monoidal law of identity" $ (root / "a") <> mempty == (root / "a")
    assert "Path conforms on the monoidal law of identity" $ mempty <> (root / "a") == (root / "a")
  test "root is identity" do
    assert "" $ (root / "foo") <> root == root / "foo"
  test "joinPath is append" do
    assert "" $ (mempty / "foo") `joinPath` mempty == mempty / "foo"

testFileNameAsString :: Free TestF Unit
testFileNameAsString = suite "fileNameAsString does what it says on the tin" do
  test "with and without extension" do
    let fp = filePath (root / "a") "foo" "txt"
    assert "without extension" $ "foo" == fileNameAsString fp false
    assert "with extension" $ "foo.txt" == fileNameAsString fp true

testFileExtensionAsString :: Free TestF Unit
testFileExtensionAsString = suite "fileExtensionAsString also does what it says" do
  test "" do
    let fp = filePath (root / "a") "foo" "txt"
    assert "" $ "txt" == fileExtensionAsString fp
