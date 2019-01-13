module Test.Common (
  assertEquals
) where

import Data.Eq (class Eq, (==))
import Data.Function (($))
import Data.Semigroup ((<>))
import Data.Show (class Show, show)
import Test.Unit (Test)
import Test.Unit.Assert (assert)

assertEquals :: forall a . Show a => Eq a => a -> a -> Test
assertEquals expected actual = assert ("Expected: " <> show expected <> ", actual: " <> show actual) $
                               expected == actual
