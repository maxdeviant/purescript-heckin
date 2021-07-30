module Data.String.Casing
  ( toCamelCase
  , toPascalCase
  , toSnakeCase
  , toScreamingSnakeCase
  , toKebabCase
  , toTitleCase
  ) where

import Prelude
import Data.Array (all, catMaybes, concat, elem, reverse, snoc, uncons, (:))
import Data.CodePoint.Unicode as CodePoint
import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..))
import Data.String.CodePoints (CodePoint, codePointFromChar, fromCodePointArray, toCodePointArray)
import Data.Tuple (Tuple(..))

stringToMaybe :: String -> Maybe String
stringToMaybe "" = Nothing

stringToMaybe value = Just value

mapHead :: forall a. (a -> a) -> Array a -> Array a
mapHead mapping arr = case uncons arr of
  Just { head: x, tail: xs } -> mapping x : xs
  Nothing -> arr

mapTail :: forall a. (a -> a) -> Array a -> Array a
mapTail mapping arr = case uncons arr of
  Just { head: x, tail: xs } -> x : map mapping xs
  Nothing -> arr

capitalize :: Array CodePoint -> Array CodePoint
capitalize = mapHead CodePoint.toUpperSimple <<< mapTail CodePoint.toLowerSimple

uncons2 :: forall a. Array a -> Maybe { x :: a, y :: a, rest :: Array a }
uncons2 arr = do
  { head: x, tail: xs } <- uncons arr
  { head: y, tail: rest } <- uncons xs
  pure $ { x, y, rest }

isSeparator :: CodePoint -> Boolean
isSeparator codePoint = elem codePoint separators
  where
  separators = [ '_', '-', ' ' ] # map codePointFromChar

isBoundary :: CodePoint -> CodePoint -> Boolean
isBoundary _currentChar nextChar
  | isSeparator nextChar = true

isBoundary currentChar nextChar = CodePoint.isLower currentChar && CodePoint.isUpper nextChar

getWords :: String -> Array String
getWords value = reverse $ catMaybes $ map stringToMaybe $ getWords' [] [] $ toCodePointArray value
  where
  getWords' :: Array CodePoint -> Array String -> Array CodePoint -> Array String
  getWords' currentWord acc [] = fromCodePointArray currentWord : acc

  getWords' currentWord acc [ singleChar ] = fromCodePointArray (currentWord `snoc` singleChar) : acc

  getWords' currentWord acc chars = case uncons2 chars of
    Just { x: currentChar, y: nextChar, rest: remainingChars } ->
      let
        appendCurrentChar :: Array CodePoint -> Array CodePoint
        appendCurrentChar word =
          if isSeparator currentChar then
            word
          else
            concat [ word, [ currentChar ] ]

        (Tuple currentWord' acc') =
          if isBoundary currentChar nextChar then
            Tuple "" (fromCodePointArray (appendCurrentChar currentWord) : acc)
          else
            if all CodePoint.isUpper currentWord
              && CodePoint.isUpper currentChar
              && CodePoint.isLower nextChar then
              Tuple (fromCodePointArray $ appendCurrentChar []) (fromCodePointArray currentWord : acc)
            else
              Tuple (fromCodePointArray $ appendCurrentChar currentWord) acc

        remainingChars' =
          if not $ isSeparator nextChar then
            nextChar : remainingChars
          else
            remainingChars
      in
        getWords' (toCodePointArray currentWord') acc' remainingChars'
    Nothing -> acc

-- | Converts the given string to camelCase.
-- |
-- | In camelCase each word starts with an uppercase letter except for the first
-- | word, which starts with a lowercase letter.
-- |
-- | ```purescript
-- | toCamelCase "Hello World" == "helloWorld"
-- | toCamelCase "Player ID" == "playerId"
-- | toCamelCase "XMLHttpRequest" == "xmlHttpRequest"
-- | ```
toCamelCase :: String -> String
toCamelCase =
  intercalate ""
    <<< map fromCodePointArray
    <<< mapTail capitalize
    <<< mapHead (map CodePoint.toLowerSimple)
    <<< map toCodePointArray
    <<< getWords

-- | Converts the given string to PascalCase.
-- |
-- | In PascalCase the first letter of each word is uppercase.
-- |
-- | ```purescript
-- | toPascalCase "Hello World" == "HelloWorld"
-- | toPascalCase "Player ID" == "PlayerId"
-- | toPascalCase "XMLHttpRequest" == "XmlHttpRequest"
-- | ```
toPascalCase :: String -> String
toPascalCase =
  intercalate ""
    <<< map fromCodePointArray
    <<< map capitalize
    <<< map toCodePointArray
    <<< getWords

-- | Converts the given string to snake_case.
-- |
-- | In snake_case all letters are lowercase and each word is separated by an
-- | underscore (`_`).
-- |
-- | ```purescript
-- | toSnakeCase "Hello World" == "hello_world"
-- | toSnakeCase "Player ID" == "player_id"
-- | toSnakeCase "XMLHttpRequest" == "xml_http_request"
-- | ```
toSnakeCase :: String -> String
toSnakeCase =
  intercalate "_"
    <<< map fromCodePointArray
    <<< map (map CodePoint.toLowerSimple)
    <<< map toCodePointArray
    <<< getWords

-- | Converts the given string to SCREAMING_SNAKE_CASE.
-- |
-- | In SCREAMING_SNAKE_CASE all letters are uppercase and each word is separated
-- | by an underscore (`_`).
-- |
-- | ```purescript
-- | toScreamingSnakeCase "Hello World" == "HELLO_WORLD"
-- | toScreamingSnakeCase "Player ID" == "PLAYER_ID"
-- | toScreamingSnakeCase "XMLHttpRequest" == "XML_HTTP_REQUEST"
-- | ```
toScreamingSnakeCase :: String -> String
toScreamingSnakeCase =
  intercalate "_"
    <<< map fromCodePointArray
    <<< map (map CodePoint.toUpperSimple)
    <<< map toCodePointArray
    <<< getWords

-- | Converts the given string to kebab-case.
-- |
-- | In kebab-case all letters are lowercase and each word is separated by a
-- | hyphen (`-`).
-- |
-- | ```purescript
-- | toKebabCase "Hello World" == "hello-world"
-- | toKebabCase "Player ID" == "player-id"
-- | toKebabCase "XMLHttpRequest" == "xml-http-request"
-- | ```
toKebabCase :: String -> String
toKebabCase =
  intercalate "-"
    <<< map fromCodePointArray
    <<< map (map CodePoint.toLowerSimple)
    <<< map toCodePointArray
    <<< getWords

-- | Converts the given string to Title Case.
-- |
-- | In Title Case the first letter of each word is uppercase and each word is
-- | separated by a space (` `).
-- |
-- | ```purescript
-- | toTitleCase "Hello World" == "Hello World"
-- | toTitleCase "Player ID" == "Player Id"
-- | toTitleCase "XMLHttpRequest" == "Xml Http Request"
-- | ```
toTitleCase :: String -> String
toTitleCase =
  intercalate " "
    <<< map fromCodePointArray
    <<< map capitalize
    <<< map toCodePointArray
    <<< getWords
