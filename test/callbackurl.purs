module Test.CallbackURL(testCallbackURL) where

import CallbackURL (getURL, newCallbackURL, addParameter)
import Control.Bind (discard)
import Control.Monad.Free (Free)
import Data.Unit (Unit)
import Test.Common (assertEquals)
import Test.Unit (suite, test, TestF)

testCallbackURL :: Free TestF Unit
testCallbackURL = suite "CallbackURL" do
  testGetURL

testGetURL :: Free TestF Unit
testGetURL = suite "getURL generates a correct URL" do
  test "no parameters" do
    assertEquals "foo://x-callback-url/bar" (getURL (newCallbackURL "foo" "bar" ))
  test "with parameters" do
    assertEquals "foo://x-callback-url/bar?one=two" (getURL (addParameter "one" "two" (newCallbackURL "foo" "bar" )))
