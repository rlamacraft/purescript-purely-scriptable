module FileManager(
  FileManager, iCloud, local,
  Path, Directory, joinPath, appendPath, (/), 
  documentDirectory, libraryDirectory, temporaryDirectory, isDirectory, listContents
  ) where

import Control.Semigroupoid ((>>>))
import Data.Foldable (intercalate)
import Data.Functor (map, (<#>))
import Data.List (List, fromFoldable, singleton) as List
import Data.Monoid (class Monoid, (<>), mempty)
import Data.Newtype (class Newtype, over2, un)
import Data.Semigroup (class Semigroup, append)
import Data.String.Common (split)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)

-----------------------
-- Path
-----------------------

newtype Directory = Directory String
derive instance newtypeDirectory :: Newtype Directory _

newtype Path = Path (List.List Directory)
derive instance newtypePath :: Newtype Path _

instance semigroupPath :: Semigroup Path where
  append = over2 Path (<>)

instance monoidPath :: Monoid Path where
  mempty = Path mempty

pathSeparator :: Pattern
pathSeparator = Pattern "/"

split' :: Pattern -> String -> List.List String
split' pattern = split pattern >>> List.fromFoldable

toPath :: String -> Path
toPath = split' pathSeparator >>> map Directory >>> Path

fromPath :: Path -> String
fromPath = un Path >>> map (un Directory) >>> intercalate (un Pattern pathSeparator)

joinPath :: Path -> Path -> Path
joinPath = append

singleton :: Directory -> Path
singleton = List.singleton >>> Path

appendPath :: Path -> Directory -> Path
appendPath path = singleton >>> joinPath path

infixl 9 appendPath as /

-----------------------
-- FileManager APIs
-----------------------

data FileManager
  = Icloud
  | Local

iCloud :: FileManager
iCloud = Icloud

local :: FileManager
local = Local

fileManagerName :: FileManager -> String
fileManagerName Icloud = "iCloud"
fileManagerName Local = "local"

-----------------------
-- Directory APIs
-----------------------

documentDirectory :: FileManager -> Effect Path
documentDirectory = documentDirectory_Impl >>> map toPath

foreign import documentDirectory_Impl :: FileManager -> Effect String

libraryDirectory :: FileManager -> Effect Path
libraryDirectory = libraryDirectory_Impl >>> map toPath

foreign import libraryDirectory_Impl :: FileManager -> Effect String

temporaryDirectory :: FileManager -> Effect Path
temporaryDirectory = temporaryDirectory_Impl >>> map toPath

foreign import temporaryDirectory_Impl :: FileManager -> Effect String

isDirectory :: FileManager -> Path -> Effect Boolean
isDirectory fileManager path = isDirectory_Impl (fileManagerName fileManager) (fromPath path)

foreign import isDirectory_Impl :: String -> String -> Effect Boolean

listContents :: FileManager -> Path -> Effect (List.List Path)
listContents fileManager path = listContents_Impl (fileManagerName fileManager) (fromPath path)
                                <#> List.fromFoldable >>> map toPath

foreign import listContents_Impl :: String -> String -> Effect (Array String)
