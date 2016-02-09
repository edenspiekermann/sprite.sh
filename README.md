# Sprite.sh

A Bash script to build a SVG sprite from a folder of SVG files (typically icons).

## Usage

```sh
bin/sprite.sh <dir>
bin/sprite.sh <dir> [-o|--output <file>] [-v|--viewport <string>] [-p|--prefix <string>]
```

## Example

1. Generate `sprite.svg` from SVG files in current folder.

    ```sh
    bin/sprite.sh ./
    ```

2. Generate `sprite.svg` from SVG files in `assets/images/icons`.

    ```sh
    bin/sprite.sh assets/images/icons/
    ```

3. Generate `_includes/icons.svg` from SVG files in current folder.

    ```sh
    bin/sprite.sh ./ -o _includes/icons.svg
    ```

4. Generate `_includes/icons.svg` from SVG files in current folder with a view box of `0 0 16 16`.

    ```sh
    bin/sprite.sh ./ -o _includes/icons.svg -v "0 0 16 16"
    ```

5. Generate `_includes/icons.svg` from SVG files in current folder with a view box of `0 0 16 16`, and `id` attributes prefixed with `i_`.

    ```sh
    bin/sprite.sh ./ -o _includes/icons.svg -v "0 0 16 16" -p i_
    ```
