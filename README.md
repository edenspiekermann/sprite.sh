# spritesh

A Node.js script to build a SVG sprite from a folder of SVG files (typically icons).

## Install

```
npm install spritesh -g
```

```
gem install spritesh
```

*Or you know, you can also just copy [the script](https://raw.githubusercontent.com/edenspiekermann/sprite.sh/master/bin/spritesh.js).*

## Usage

```
Usage: spritesh [options]
Script to build a SVG sprite from a folder of SVG files.
Options:
  -h, --help             Shows this help
  -q, --quiet            Disables informative output
  -i, --input [dir]      Specifies input dir (current dir by default)
  -o, --output [file]    Specifies output file ("./sprite.svg" by default)
  -v, --viewbox [str]    Specifies viewBox attribute (parsed by default)
  -p, --prefix [str]     Specifies prefix for id attribute (none by default)
```

## Examples

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

## SVG Optimisation

spritesh is a teeny tiny Bash script that takes care of SVG files concatenation; it does not perform any SVG optimisation. I recommend you add [svgo](https://github.com/svg/svgo) (or similar tool) to your workflow to have an optimised and efficient SVG sprite.

An example that starts with improving the SVG files, then build a sprite could be:

```
svgo -f assets/images/icons && spritesh -i assets/images/icons
```

## Accessibility

spritesh doesn’t help with SVG icons accessibility in itself. It is the responsibility of the developer (a.k.a *you*) to make sure the original icon files are including the relevant accessibility bits: a `<title>` tag with and `id` attribute.

For instance, a `logo.svg` icon could look like this:

```svg
<svg …>
  <title id="icon-brand-name">Your company/product name here</title>
  <!-- SVG content -->
</svg>
```

Which will generate this sprite (where `icon-` is the `--prefix` option):

```svg
<!-- sprite -->
<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
  <symbol id="icon-brand" viewBox="0 0 20 20">
    <svg …>
      <title id="icon-brand-name">Your company/product name here</title>
      <!-- SVG Content -->
    </svg>
  </symbol>
  <!-- Other symbols -->
</svg>
```

Later on, when using the sprite through `<svg>`/`<use>`, add an `aria-labelledby` attribute to the `<svg>` element referencing the relevant `<title>` id.

```html
<svg class="logo" aria-labelledby="icon-brand-name">
  <use xlink:href="#icon-brand"></use>
</svg>
```
