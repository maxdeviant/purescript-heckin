module Data.String.Casing
  ( toCamelCase
  , toPascalCase
  , toSnakeCase
  , toScreamingSnakeCase
  , toKebabCase
  , toTitleCase
  ) where

import Prelude
import Data.Array (all, catMaybes, concat, reverse, snoc, uncons, (:))
import Data.Char.Unicode as Char
import Data.Foldable (intercalate)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (fromCharArray, toCharArray)
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

capitalize :: Array Char -> Array Char
capitalize = mapHead Char.toUpper <<< mapTail Char.toLower

uncons2 :: forall a. Array a -> Maybe { x :: a, y :: a, rest :: Array a }
uncons2 arr = case uncons arr of
  Just { head: x, tail: xs } -> case uncons xs of
    Just { head: y, tail: rest } -> Just { x, y, rest }
    Nothing -> Nothing
  Nothing -> Nothing

isSeparator :: Char -> Boolean
isSeparator '_' = true

isSeparator '-' = true

isSeparator ' ' = true

isSeparator _ = false

isBoundary :: Char -> Char -> Boolean
isBoundary _currentChar nextChar
  | isSeparator nextChar = true

isBoundary currentChar nextChar = Char.isLower currentChar && Char.isUpper nextChar

getWords :: String -> Array String
getWords value = reverse $ catMaybes $ map stringToMaybe $ getWords' [] [] $ toCharArray value
  where
  getWords' :: Array Char -> Array String -> Array Char -> Array String
  getWords' currentWord acc [] = fromCharArray currentWord : acc

  getWords' currentWord acc [ singleChar ] = fromCharArray (currentWord `snoc` singleChar) : acc

  getWords' currentWord acc chars = case uncons2 chars of
    Just { x: currentChar, y: nextChar, rest: remainingChars } ->
      let
        appendCurrentChar :: Array Char -> Array Char
        appendCurrentChar word =
          if isSeparator currentChar then
            word
          else
            concat [ word, [ currentChar ] ]

        (Tuple currentWord' acc') =
          if isBoundary currentChar nextChar then
            Tuple "" (fromCharArray (appendCurrentChar currentWord) : acc)
          else
            if all Char.isUpper currentWord
              && Char.isUpper currentChar
              && Char.isLower nextChar then
              Tuple (fromCharArray $ appendCurrentChar []) (fromCharArray currentWord : acc)
            else
              Tuple (fromCharArray $ appendCurrentChar currentWord) acc

        remainingChars' =
          if not $ isSeparator nextChar then
            nextChar : remainingChars
          else
            remainingChars
      in
        getWords' (toCharArray currentWord') acc' remainingChars'
    Nothing -> acc

-- | Converts the given string to camelCase.
-- |
-- | In camelCase each word starts with an uppercase letter except for the first
-- | word, which starts with a lowercase letter.
-- |
-- | ```purescript
-- | toCamelCase "Hello World" = "helloWorld"
-- | toCamelCase "Player ID" = "playerId"
-- | toCamelCase "XMLHttpRequest" = "xmlHttpRequest"
-- | ```
toCamelCase :: String -> String
toCamelCase =
  intercalate ""
    <<< map fromCharArray
    <<< mapTail capitalize
    <<< mapHead (map Char.toLower)
    <<< map toCharArray
    <<< getWords

-- | Converts the given string to PascalCase.
-- |
-- | In PascalCase the first letter of each word is uppercase.
-- |
-- | ```purescript
-- | toPascalCase "Hello World" = "HelloWorld"
-- | toPascalCase "Player ID" = "PlayerId"
-- | toPascalCase "XMLHttpRequest" = "XmlHttpRequest"
-- | ```
toPascalCase :: String -> String
toPascalCase =
  intercalate ""
    <<< map fromCharArray
    <<< map capitalize
    <<< map toCharArray
    <<< getWords

-- | Converts the given string to snake_case.
-- |
-- | In snake_case all letters are lowercase and each word is separated by an
-- | underscore (`_`).
-- |
-- | ```purescript
-- | toSnakeCase "Hello World" = "hello_world"
-- | toSnakeCase "Player ID" = "player_id"
-- | toSnakeCase "XMLHttpRequest" = "xml_http_request"
-- | ```
toSnakeCase :: String -> String
toSnakeCase =
  intercalate "_"
    <<< map fromCharArray
    <<< map (map Char.toLower)
    <<< map toCharArray
    <<< getWords

-- | Converts the given string to SCREAMING_SNAKE_CASE.
-- |
-- | In SCREAMING_SNAKE_CASE all letters are uppercase and each word is separated
-- | by an underscore (`_`).
-- |
-- | ```purescript
-- | toScreamingSnakeCase "Hello World" = "HELLO_WORLD"
-- | toScreamingSnakeCase "Player ID" = "PLAYER_ID"
-- | toScreamingSnakeCase "XMLHttpRequest" = "XML_HTTP_REQUEST"
-- | ```
toScreamingSnakeCase :: String -> String
toScreamingSnakeCase =
  intercalate "_"
    <<< map fromCharArray
    <<< map (map Char.toUpper)
    <<< map toCharArray
    <<< getWords

-- | Converts the given string to kebab-case.
-- |
-- | In kebab-case all letters are lowercase and each word is separated by a
-- | hyphen (`-`).
-- |
-- | ```purescript
-- | toKebabCase "Hello World" = "hello-world"
-- | toKebabCase "Player ID" = "player-id"
-- | toKebabCase "XMLHttpRequest" = "xml-http-request"
-- | ```
toKebabCase :: String -> String
toKebabCase =
  intercalate "-"
    <<< map fromCharArray
    <<< map (map Char.toLower)
    <<< map toCharArray
    <<< getWords

-- | Converts the given string to Title Case.
-- |
-- | In Title Case the first letter of each word is uppercase and each word is
-- | separated by a space (` `).
-- |
-- | ```purescript
-- | toTitleCase "Hello World" = "Hello World"
-- | toTitleCase "Player ID" = "Player Id"
-- | toTitleCase "XMLHttpRequest" = "Xml Http Request"
-- | ```
toTitleCase :: String -> String
toTitleCase =
  intercalate " "
    <<< map fromCharArray
    <<< map capitalize
    <<< map toCharArray
    <<< getWords
