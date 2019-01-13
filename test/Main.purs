module Test.Main where

import Prelude

import Effect(Effect)

import Test.Unit.Main (runTest)
import Test.FileManager (testFileManager)
import Test.UITable (testUITable)

main :: Effect Unit
main = runTest do
  testFileManager
  testUITable
  
