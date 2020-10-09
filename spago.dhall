{ name = "heckin"
, license = "MIT"
, repository = "https://github.com/maxdeviant/purescript-heckin"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "foldable-traversable"
  , "psci-support"
  , "spec"
  , "unicode"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
