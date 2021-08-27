# purescript-heckin

[![Pursuit](https://pursuit.purescript.org/packages/purescript-heckin/badge)](https://pursuit.purescript.org/packages/purescript-heckin)

> Oh heck, it's a heckin' case conversion library for PureScript

`heckin` provides functions for converting between various casing conventions.

## Supported Casing Conventions

- `camelCase`
- `PascalCase`
- `snake_case`
- `SCREAMING_SNAKE_CASE`
- `kebab-case`
- `Title Case`

## Installation

You can install `heckin` with [Spago](https://github.com/purescript/spago):

```sh
spago install heckin
```

## Usage

To use `heckin`, import your desired casing functions and call them. All of the casing functions have a signature of `String -> String`.

In the REPL:

```
> import Data.String.Casing

> toSnakeCase "helloWorld"
"hello_world"

> toCamelCase "hello_world"
"helloWorld"
```

## Documentation

Documentation is [available on Pursuit](https://pursuit.purescript.org/packages/purescript-heckin).

## Prior Art

This library was inspired by [heck](https://github.com/withoutboats/heck), both in name and behavior.
