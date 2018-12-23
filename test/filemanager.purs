module Test.FileManager where

import Control.Monad.Free(Free)
import Prelude
import Test.Unit (suite, test, TestF)
import Test.Unit.Assert as Assert

testFileManager :: Free TestF Unit
testFileManager = suite "hello world" do
    test "arithmetoc" do
      Assert.assert "2 + 2 should be 4" $ (2 + 2) == 4
