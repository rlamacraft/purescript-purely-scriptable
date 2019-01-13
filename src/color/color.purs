module PurelyScriptable.Color (
  newColor, ForeignConstructableColor(..), toForeignConstructable,
  black, blue, brown, clear, cyan, darkGray, gray, green,
  lightGray, magenta, orange, purple, red, white, yellow
  ) where

import Color (Color, fromHexString, rgba, rgba', toHexString, toRGBA)
import Data.Function ((#))
import Data.Functor ((<#>))
import Data.Maybe (Maybe)

setAlpha :: Number -> Color -> Color
setAlpha alpha c = rgba r g b alpha where
  {r : r, g : g, b : b} = toRGBA c

newColor :: String -> Number -> Maybe Color
newColor h alpha = fromHexString h <#> setAlpha alpha

type ForeignConstructableColor = {
  hex :: String,
  alpha :: Number
}

toForeignConstructable :: Color -> ForeignConstructableColor
toForeignConstructable c = {hex : toHexString c, alpha : (toRGBA c).a} 

-----------------------
-- Colors
-----------------------

type ForeignColor = {
  alpha :: Number,
  red :: Number,
  green :: Number,
  blue :: Number
}

fromForeign :: ForeignColor -> Color
fromForeign {red : r', green : g', blue : b', alpha : a'} = rgba' r' g' b' a'

black :: Color
black = black_Impl # fromForeign

foreign import black_Impl :: ForeignColor

blue :: Color
blue = blue_Impl # fromForeign

foreign import blue_Impl :: ForeignColor

brown :: Color
brown = brown_Impl # fromForeign

foreign import brown_Impl :: ForeignColor

clear :: Color
clear = clear_Impl # fromForeign

foreign import clear_Impl :: ForeignColor

cyan :: Color
cyan = cyan_Impl # fromForeign

foreign import cyan_Impl :: ForeignColor

darkGray :: Color
darkGray = darkGray_Impl # fromForeign

foreign import darkGray_Impl :: ForeignColor

gray :: Color
gray = gray_Impl # fromForeign

foreign import gray_Impl :: ForeignColor

green :: Color
green = green_Impl # fromForeign

foreign import green_Impl :: ForeignColor

lightGray :: Color
lightGray = lightGray_Impl # fromForeign

foreign import lightGray_Impl :: ForeignColor

magenta :: Color
magenta = magenta_Impl # fromForeign

foreign import magenta_Impl :: ForeignColor

orange :: Color
orange = orange_Impl # fromForeign

foreign import orange_Impl :: ForeignColor

purple :: Color
purple = purple_Impl # fromForeign

foreign import purple_Impl :: ForeignColor

red :: Color
red = red_Impl # fromForeign

foreign import red_Impl :: ForeignColor

white :: Color
white = white_Impl # fromForeign

foreign import white_Impl :: ForeignColor

yellow :: Color
yellow = yellow_Impl # fromForeign

foreign import yellow_Impl :: ForeignColor

