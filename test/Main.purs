module Test.Main where

import Prelude
import Control.Monad.Error.Class (class MonadThrow)
import Data.String.Casing as Casing
import Effect (Effect)
import Effect.Aff (Error, launchAff_)
import Test.Spec (SpecT, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

makeTest ::
  forall t4 t7.
  Monad t7 =>
  MonadThrow Error t4 =>
  (String -> String) -> String -> String -> SpecT t4 Unit t7 Unit
makeTest transform value expected =
  it ("properly converts \"" <> value <> "\" to \"" <> expected <> "\"") do
    transform value `shouldEqual` expected

main :: Effect Unit
main = do
  launchAff_
    $ runSpec [ consoleReporter ] do
        describe "Casing.toCamelCase" do
          let
            test = makeTest Casing.toCamelCase
          test "camelCase" "camelCase"
          test "PascalCase" "pascalCase"
          test "snake_case" "snakeCase"
          test "SCREAMING_SNAKE_CASE" "screamingSnakeCase"
          test "kebab-case" "kebabCase"
          test "Title Case" "titleCase"
          test "XMLHttpRequest" "xmlHttpRequest"
          test "PlayerID" "playerId"
          test "IODevice" "ioDevice"
          test "NASA" "nasa"
          test "Two  Spaces" "twoSpaces"
          test "Three   Spaces" "threeSpaces"
          test "Two__Underscores" "twoUnderscores"
          test "Three___Underscores" "threeUnderscores"
          test "this-contains_ ALLKinds OfWord_Boundaries" "thisContainsAllKindsOfWordBoundaries"
        describe "Casing.toSnakeCase" do
          let
            test = makeTest Casing.toSnakeCase
          test "camelCase" "camel_case"
          test "PascalCase" "pascal_case"
          test "snake_case" "snake_case"
          test "SCREAMING_SNAKE_CASE" "screaming_snake_case"
          test "kebab-case" "kebab_case"
          test "Title Case" "title_case"
          test "XMLHttpRequest" "xml_http_request"
          test "PlayerID" "player_id"
          test "IODevice" "io_device"
          test "NASA" "nasa"
          test "Two  Spaces" "two_spaces"
          test "Three   Spaces" "three_spaces"
          test "Two__Underscores" "two_underscores"
          test "Three___Underscores" "three_underscores"
          test "this-contains_ ALLKinds OfWord_Boundaries" "this_contains_all_kinds_of_word_boundaries"
        describe "Casing.toScreamingSnakeCase" do
          let
            test = makeTest Casing.toScreamingSnakeCase
          test "camelCase" "CAMEL_CASE"
          test "PascalCase" "PASCAL_CASE"
          test "snake_case" "SNAKE_CASE"
          test "SCREAMING_SNAKE_CASE" "SCREAMING_SNAKE_CASE"
          test "kebab-case" "KEBAB_CASE"
          test "Title Case" "TITLE_CASE"
          test "XMLHttpRequest" "XML_HTTP_REQUEST"
          test "PlayerID" "PLAYER_ID"
          test "IODevice" "IO_DEVICE"
          test "NASA" "NASA"
          test "Two  Spaces" "TWO_SPACES"
          test "Three   Spaces" "THREE_SPACES"
          test "Two__Underscores" "TWO_UNDERSCORES"
          test "Three___Underscores" "THREE_UNDERSCORES"
          test "this-contains_ ALLKinds OfWord_Boundaries" "THIS_CONTAINS_ALL_KINDS_OF_WORD_BOUNDARIES"
        describe "Casing.toKebabCase" do
          let
            test = makeTest Casing.toKebabCase
          test "camelCase" "camel-case"
          test "PascalCase" "pascal-case"
          test "snake_case" "snake-case"
          test "SCREAMING_SNAKE_CASE" "screaming-snake-case"
          test "kebab-case" "kebab-case"
          test "Title Case" "title-case"
          test "XMLHttpRequest" "xml-http-request"
          test "PlayerID" "player-id"
          test "IODevice" "io-device"
          test "NASA" "nasa"
          test "Two  Spaces" "two-spaces"
          test "Three   Spaces" "three-spaces"
          test "Two__Underscores" "two-underscores"
          test "Three___Underscores" "three-underscores"
          test "this-contains_ ALLKinds OfWord_Boundaries" "this-contains-all-kinds-of-word-boundaries"
        describe "Casing.toTitleCase" do
          let
            test = makeTest Casing.toTitleCase
          test "camelCase" "Camel Case"
          test "PascalCase" "Pascal Case"
          test "snake_case" "Snake Case"
          test "SCREAMING_SNAKE_CASE" "Screaming Snake Case"
          test "kebab-case" "Kebab Case"
          test "Title Case" "Title Case"
          test "XMLHttpRequest" "Xml Http Request"
          test "PlayerID" "Player Id"
          test "IODevice" "Io Device"
          test "NASA" "Nasa"
          test "Two  Spaces" "Two Spaces"
          test "Three   Spaces" "Three Spaces"
          test "Two__Underscores" "Two Underscores"
          test "Three___Underscores" "Three Underscores"
          test "this-contains_ ALLKinds OfWord_Boundaries" "This Contains All Kinds Of Word Boundaries"
