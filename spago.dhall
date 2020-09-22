{ name = "heckin"
, license = "MIT"
, repository = "https://github.com/maxdeviant/heckin"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "foldable-traversable"
  , "psci-support"
  , "unicode"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
