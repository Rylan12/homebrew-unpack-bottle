# homebrew-unpack-bottle

> [!CAUTION]
> This command no longer works, and I don't use it regularly enough to bother updating it right now.
> I've archived the repository, and if I find that I need this command again I will fix it and add it to my personal tap: [Rylan12/homebrew-personal](https://github.com/Rylan12/homebrew-personal).

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
