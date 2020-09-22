{ name = "heckin"
, license = "MIT"
, repository = "https://github.com/maxdeviant/heckin"
, dependencies = [ "console", "effect", "psci-support" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
