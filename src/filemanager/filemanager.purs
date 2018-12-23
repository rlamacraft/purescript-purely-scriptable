module FileManager(
  FileManager, iCloud, local,
  Path, Directory, joinPath, appendPathAsString, (/), root,
  documentDirectory, libraryDirectory, temporaryDirectory, isDirectory, listContents,
  FilePath(..), FileName, FileExtension, filePath, fileNameAsString, fileExists,
  readString, writeString
  ) where

import Control.Semigroupoid ((>>>))
import Data.Eq (class Eq, (==))
import Data.Foldable (intercalate)
import Data.Function ((#))
import Data.Functor (map, (<#>))
import Data.List (List, fromFoldable, singleton) as List
import Data.Monoid (class Monoid, mempty, (<>))
import Data.Newtype (class Newtype, over2, un)
import Data.Semigroup (class Semigroup, append)
import Data.Show (class Show, show)
import Data.String.Common (split)
import Data.String.Pattern (Pattern(..))
import Data.Unit (Unit)
import Effect (Effect)

-----------------------
-- Path
-----------------------

newtype Directory = Directory String
derive instance newtypeDirectory :: Newtype Directory _

instance eqDirectory :: Eq Directory where
  eq (Directory x) (Directory y) = x == y

newtype Path = Path (List.List Directory)
derive instance newtypePath :: Newtype Path _

instance semigroupPath :: Semigroup Path where
  append = over2 Path append

instance monoidPath :: Monoid Path where
  mempty = Path mempty

instance eqPath :: Eq Path where
  eq (Path xs) (Path ys) = xs == ys

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

appendPathAsString :: Path -> String -> Path
appendPathAsString path str = Directory str # appendPath path

infixl 9 appendPathAsString as /

root :: Path
root = Path mempty

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
isDirectory fm path = isDirectory_Impl (fileManagerName fm) (fromPath path)

foreign import isDirectory_Impl :: String -> String -> Effect Boolean

listContents :: FileManager -> Path -> Effect (List.List Path)
listContents fm path = listContents_Impl (fileManagerName fm) (fromPath path)
                                <#> List.fromFoldable >>> map toPath

foreign import listContents_Impl :: String -> String -> Effect (Array String)

-----------------------
-- File APIs
-----------------------

newtype FileName = FileName String
derive instance newtypeFilename :: Newtype FileName _

newtype FileExtension = FileExtension String
derive instance newtypeFileExtension :: Newtype FileExtension _

data FilePath = FilePath Path FileName FileExtension

filePath :: Path -> String -> String -> FilePath
filePath path name ext = FilePath path (FileName name) (FileExtension ext)

instance showFilePath :: Show FilePath where
  show fp@(FilePath path _ _) = fromPath path <>
                                un Pattern pathSeparator <>
                                fileNameAsString fp true

fileNameAsString :: FilePath -> Boolean -> String
fileNameAsString fp@(FilePath _ _ ext) true = fileNameAsString fp false <>
                                              "." <>
                                              un FileExtension ext
fileNameAsString (FilePath _ name _) false = un FileName name

fileExists :: FileManager -> FilePath -> Effect Boolean
fileExists fm path = fileExists_Impl (fileManagerName fm) (show path)

foreign import fileExists_Impl :: String -> String -> Effect Boolean

-----------------------
-- Plain Text APIs
-----------------------

readString :: FileManager -> FilePath -> Effect String
readString fm path = readString_Impl (fileManagerName fm) (show path)

foreign import readString_Impl :: String -> String -> Effect String

writeString :: FileManager -> FilePath -> String -> Effect Unit
writeString fm path content = writeString_Impl (fileManagerName fm) (show path) content

foreign import writeString_Impl :: String -> String -> String -> Effect Unit
