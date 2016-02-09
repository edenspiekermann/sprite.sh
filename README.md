# Sprite.sh

A Bash script to build a SVG sprite from a folder of SVG files (typically icons).

## Usage

```sh
bin/sprite.sh 
bin/sprite.sh [<SVG_FILES> <DEST_FILE> <VIEWBOX> <ICON_PREFIX>]
```

*This is a very simple shell script. Arguments have to come in order (if needed as sensible defaults are provided) and cannot be named.*

**Be sure to quote the glob pattern (first argument).**

## Example

1. Generate `sprite.svg` from SVG files in current folder.

    ```sh
    bin/sprite.sh
    ```

2. Generate `sprite.svg` from SVG files in `assets/images/icons`.

    ```sh
    bin/sprite.sh "assets/images/icons/*"
    ```

3. Generate `_includes/icons.svg` from SVG files in `assets/images/icons`.

    ```sh
    bin/sprite.sh "assets/images/icons/*" _includes/icons.svg
    ```

4. Generate `_includes/icons.svg` from SVG files in `assets/images/icons` with a view box of `0 0 16 16`.

    ```sh
    bin/sprite.sh "assets/images/icons/*" _includes/icons.svg "0 0 16 16"
    ```

5. Generate `_includes/icons.svg` from SVG files in `assets/images/icons` with a view box of `0 0 16 16`, and `id` attributes prefixed with `rbi_`.

    ```sh
    bin/sprite.sh "assets/images/icons/*" _includes/icons.svg "0 0 16 16" "rbi_"
    ```
