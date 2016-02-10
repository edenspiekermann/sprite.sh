# spritesh

A Bash script to build a SVG sprite from a folder of SVG files (typically icons).

## Install

```
npm install spritesh -g
```

*Or you know, you can also just copy [the script](https://github.com/edenspiekermann/sprite.sh/blob/master/spritesh).*

## Usage

```sh
Usage: spritesh [options]
Script to build a SVG sprite from a folder of SVG files.
Options:
  -h, --help             shows this help
  -q, --quiet            disables output
  -i, --input [dir]      specify input dir (current dir by default)
  -o, --output [file]    specify output file ("./sprite.svg" by default)
  -v, --viewbox [str]    specify viewbox attribute ("0 0 20 20" by default)
  -p, --prefix [str]     specify prefix for id attribute (none by default)
```

## Example

1. Generate `sprite.svg` from SVG files in current folder (all defaults).

    ```sh
    spritesh
    ```

2. Generate `sprite.svg` from SVG files in `assets/images/icons`.

    ```sh
    spritesh --input assets/images/icons
    ```

3. Generate `_includes/icons.svg` from SVG files in current folder.

    ```sh
    spritesh --output _includes/icons.svg
    ```

4. Generate `sprite.svg` from SVG files in current folder with a view box of `0 0 16 16`.

    ```sh
    spritesh --viewbox "0 0 16 16"
    ```

5. Generate `sprite.svg` from SVG files in current folder with `id` attributes prefixed with `i_`.

    ```sh
    spritesh --prefix i_
    ```
