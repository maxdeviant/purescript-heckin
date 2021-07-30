{ name = "heckin"
, license = "MIT"
, repository = "https://github.com/maxdeviant/purescript-heckin"
, dependencies =
  [ "aff"
  , "arrays"
  , "effect"
  , "foldable-traversable"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "spec"
  , "strings"
  , "transformers"
  , "tuples"
  , "unicode"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
