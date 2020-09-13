# homebrew-unpack-bottle

External [Homebrew](https://github.com/Homebrew/brew) command to unpack the bottles for formula into subdirectories of the current working directory (similar to `brew extract`).

## Installation

```sh
brew tap rylan12/unpack-bottle
```

## Usage

```sh
brew unpack-bottle <formula> [--destdir <dir>] [-f | --force]
```

Pass multiple formulae to unpack the bottles for each into their own subdirectories.

Use `--destdir <dir>` to unpack the bottles to `<dir>` directory instead of the current working directory.

`--force` will overwrite the destination directory if it already exists.
